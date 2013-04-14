#!/bin/zsh

echo ""
echo "========================================"
echo "Installing Zsh"
echo "========================================"

if [ "`uname -s`" = "Darwin" ]; then
  brew install zsh
  chsh -s /bin/zsh
else
  sudo apt-get install -y zsh
  sudo usermod -s /bin/zsh $USER
fi

echo ""
echo "========================================"
echo "Installing Prezto"
echo "========================================"

if [ ! -d ~/.zprezto ]; then
  git clone --recursive https://github.com/sorin-ionescu/prezto.git ~/.zprezto

  setopt EXTENDED_GLOB
  for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
    ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
  done

  echo '# Load my custom modules' >> ~/.zshrc
  echo 'for config_file in $HOME/.zsh/*.zsh; do' >> ~/.zshrc
  echo '  source $config_file' >> ~/.zshrc
  echo 'done' >> ~/.zshrc
fi

#echo ""
#echo "========================================"
#echo "Installing Oh-My-Zsh"
#echo "========================================"

#if [ ! -d ~/.oh-my-zsh ]; then
  #curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh
#fi

echo ""
echo "========================================"
echo "Setting up ~/.zsh"
echo "======================================="
DIR=$(dirname $0)
DIR=$(cd -P $DIR && pwd)

rm -f ~/.zsh

ln -sf "$DIR" ~/.zsh 
ln -sf "$DIR/zshrc" ~/.zshrc
ln -sf "$DIR/zpreztorc" ~/.zpreztorc
ln -sf "$DIR/prompt_elentok_setup" ~/.zprezto/modules/prompt/functions/prompt_elentok_setup
