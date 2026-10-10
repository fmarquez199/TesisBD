sudo apt install -y cargo pkg-config libssl-dev
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# Cuando pregunte, elegir la opcion por defecto (1)
source $HOME/.cargo/env
rustup install 1.64.0
rustup default 1.64.0 # Esto hara que corra la version 1.64.0 globalmente.
git clone https://github.com/hubblo-org/scaphandre.git # Codigo fuente
cd scaphandre && cargo build --release && cd .. # compilar el codigo
# Anadir la ruta de scaphandre a PATH para su uso en cualquier directorio
echo 'export PATH=$HOME/scaphandre/target/release:$PATH' >> ~/.bashrc
source ~/.bashrc
# Esto lo volvera ejecutable como superusuario (sudo)
sudo cp $HOME/scaphandre/target/release/scaphandre /usr/local/bin/