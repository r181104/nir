function dwmmake
make clean
make CC="cc $(pkg-config --cflags --libs x11 xft xinerama)"
end
