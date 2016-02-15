load 'scripts/photo_backup'
require 'date'

class Helper
  def initialize
    @tmpdir = Dir.mktmpdir
  end

  def tmpdir
    fail Error, 'Accessing destroyed helper' if @tmpdir.nil?
    @tmpdir
  end

  def join(filename)
    File.join(tmpdir, filename)
  end

  def mkdir(path)
    FileUtils.mkdir_p join(path)
  end

  def cp(source, target)
    FileUtils.cp join(source), join(target)
  end

  def create_photo(filename, date, exif_attribs = {})
    fullpath = join(filename)
    FileUtils.mkdir_p File.dirname(fullpath)

    system("convert -size 100x100 xc:white #{fullpath}")
    exif = MiniExiftool.new(fullpath)
    exif.date_time_original = DateTime.parse(date)
    exif.model = 'DMC-FZ300'
    exif_attribs.each { |key, value| exif[key] = value }
    exif.save
  end

  def cleanup!
    FileUtils.remove_entry tmpdir
    @tmpdir = nil
  end

  def print(message)
    puts message
    system("find #{tmpdir}")
    puts '--------------------------'
  end
end

describe PhotoBackup do
  let(:helper) { Helper.new }

  before(:each) { helper }
  after(:each) { helper.cleanup! }

  let(:subject) { described_class.new(helper.join('source'),
                                      helper.join('target')) }

  describe '#run!' do
    context 'when the photo target dir does not exist' do
      before :each do
        helper.create_photo 'source/photo1.jpg', '2016-03-01 11:12'
        subject.run!
      end

      it 'creates it' do
        expect(Dir).to exist(helper.join('target/2016/03-01'))
      end

      it 'copies the photo' do
        expect(File).to exist(helper.join('target/2016/03-01/fz300-photo1.jpg'))
      end
    end

    context 'when the photo target dir exists' do
      before :each do
        helper.create_photo 'source/photo1.jpg', '2016-03-01 11:12'
      end

      context 'when one day' do
        before :each do
          helper.mkdir 'target/2016/03-01'
        end

        context 'when the photo exists' do
          context 'when same hash' do
            it "doesn't copy" do
              helper.mkdir 'target/2016/03-01'
              helper.cp 'source/photo1.jpg',
                        'target/2016/03-01/fz300-photo1.jpg'
              expect(subject).to_not receive(:copy)
              subject.run!
            end
          end

          context 'when not same hash' do
            it "warns the user" do
              helper.mkdir 'target/2016/03-01'
              helper.cp 'source/photo1.jpg',
                        'target/2016/03-01/fz300-photo1.jpg'
              expect(subject).to_not receive(:copy)
              subject.run!
            end
          end
        end

        context 'when the photo does not exist' do
          it 'copies the photo' do
            helper.create_photo 'source/photo1.jpg', '2016-03-01 11:12'
            subject.run!
            expect(File)
              .to exist(helper.join('target/2016/03-01/fz300-photo1.jpg'))
          end
        end
      end
    end
  end
end
