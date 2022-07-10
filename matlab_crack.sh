#!/usr/bin/env zsh

# if does not exist an environment variable called $MATLAB_ROOT_DIR, declare it
if [ ${MATLAB_ROOT_DIR:=/usr/local/Polyspace/R2021a} ]; then
        echo "\$MATLAB_ROOT_DIR is unset.\nUsing the default value for Matlab root directory -> '$MATLAB_ROOT_DIR'"
fi

# add writing permission to $MATLAB_ROOT_DIR recursively
chmod --recursive u+w $MATLAB_ROOT_DIR
# crack matlab
cp ./libmwlmgrimpl.so "$MATLAB_ROOT_DIR/bin/glnxa64/matlab_startup_plugins/lmgrimpl/"
if [ ! -d "$MATLAB_ROOT_DIR/licenses" ]; then
        mkdir "$MATLAB_ROOT_DIR/licenses"
fi
cp ./license.lic "$MATLAB_ROOT_DIR/licenses"

# add the following lines to ~/.bashrc
# echo "export MATLAB_ROOT_DIR=$MATLAB_ROOT_DIR" >> ~/.zshrc
# echo 'alias matlab="$MATLAB_ROOT_DIR/bin/matlab &> /dev/null &"' >> ~/.zshrc

source ~/.zshrc

echo "done."
