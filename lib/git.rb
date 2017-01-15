require "#{ENV['DOTF']}/framework.rb"
require 'English' # for $CHILD_STATUS

class Repo
  attr_reader :local_branches, :remote_branches

  def initialize(directory)
    @directory = directory
    load_branches
  end

  def remotes
    @remotes ||= git('remote').split("\n").map { |name| Remote.new(self, name) }
  end

  def fetch_all
    remotes.each do |remote|
      unless remote.name == 'review'
        remote.fetch
        remote.prune
      end
    end

    load_branches
  end

  def load_branches
    @local_branches = {}
    @remote_branches = {}

    git('branch --all').each_line do |line|
      branch = Branch.parse(line, self)
      next if branch.name == 'HEAD'

      if branch.is_a? RemoteBranch
        @remote_branches[branch.name] = branch
      else
        @local_branches[branch.name] = branch
      end
    end

    add_remotes_to_local_branches
  end

  def add_remotes_to_local_branches
    remote_branches.each do |name, remote_branch|
      local_branch = local_branches[name]
      local_branch.remote_branches << remote_branch if local_branch
    end
  end

  def local_branches_without_remote
    local_branches.select { |name, _| !remote_branches.key? name }
  end

  def remote_branches_without_local
    remote_branches.select { |name, _| !local_branches.key? name }
  end

  def unsynced_branches
    @unsynched ||= [].tap do |pairs|
      local_branches.each do |_, local|
        local.remote_branches.each do |remote|
          pairs << Pair.new(local, remote) if local.hash != remote.hash
        end
      end
    end
  end

  def ref_info(ref)
    title, commit_time = git("show --no-patch --format='%s||%ct' #{ref}")
      .split('||')

    return RefInfo.new(ref, title, commit_time)
  end

  def git(command)
    output = `cd #{@directory} && git #{command} 2>> /tmp/git-verify.log`
    puts gray("  >> git #{command}") if ENV['VERBOSE']
    exit_code = $CHILD_STATUS.to_i
    fail GitError, "Git command returned status #{exit_code}" if exit_code != 0
    output
  end
end

class RefInfo
  attr_reader :ref, :title, :commit_time
  def initialize(ref, title, commit_time)
    @ref = ref
    @title = title
    @commit_time = Time.at(commit_time.to_i)
  end

  def to_s
    "#{@title} (#{@commit_time})"
  end
end

class GitError < Exception
end

class Remote
  attr_reader :name

  def initialize(repo, name)
    @repo = repo
    @name = name
  end

  def fetch
    print_progress "Fetching remote '#{@name}'"
    @repo.git("fetch #{@name}")
    clear_line
  end

  def prune
    print_progress "Removing dead branches from '#{@name}'"
    @repo.git("remote prune #{@name}")
    clear_line
  end
end

class Branch
  attr_reader :repo, :name, :git_name

  def initialize(repo, name)
    @repo = repo
    @name = name
    @git_name = name
  end

  def hash
    @hash ||= @repo.git("log -1 --pretty=%h #{git_name}").strip
  end

  def reset_hash!
    @hash = nil
  end

  def to_s
    @git_name
  end

  def self.parse(line, repo)
    line = line.gsub(/^\*/, '').strip
    if line.start_with? 'remotes/'
      RemoteBranch.new(repo, line)
    else
      LocalBranch.new(repo, line)
    end
  end

  def protected?
    %(master develop).include?(@name)
  end
end

class LocalBranch < Branch
  attr_reader :remote_branches

  def initialize(repo, name)
    super
    @remote_branches = []
  end
end

class RemoteBranch < Branch
  attr_reader :remote_name

  def initialize(repo, name)
    super

    name.gsub!(/ ->.*/, '')
    _, @remote_name, @name = name.split('/', 3)
    @git_name = "#{@remote_name}/#{@name}"
  end
end

