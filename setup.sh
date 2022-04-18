GLAD_GL_VERSION=${GLAD_GL_VERSION:-4.6}
GLAD_GL_PROFILE=${GLAD_GL_PROFILE:-core}

GLFW_VERSION=${GLFW_VERSION:-3.3.2}

PYTHON_PATH=${PYTHON_PATH:-python3}

if [ "$1" != "reset" ]; then
    
    mkdir ./_extern #  por algum motivo isso aqui não funciona na linha seguinte -P ./_extern 
    wget "https://github.com/Dav1dde/glad/archive/refs/heads/master.zip" -O ./_extern/glad.zip
    unzip ./_extern/glad.zip -d ./_extern
    cd ./_extern/glad-master
    "$PYTHON_PATH" -m glad --profile "$GLAD_GL_PROFILE" --api "gl=$GLAD_GL_VERSION" --generator "c" --out-path "./../../"
    cd ./../../
    mkdir src/glad
    mv src/glad.c src/glad/glad.c

    wget "https://github.com/glfw/glfw/releases/download/$GLFW_VERSION/glfw-$GLFW_VERSION.zip" -P ./_extern
    cd ./_extern
    unzip glfw-$GLFW_VERSION.zip
    cd glfw-$GLFW_VERSION
    mkdir build
    cd build
    cmake .. -DCMAKE_INSTALL_PREFIX=../../../
    make
    make install
    cd ../../../ && touch src/env.hpp
    ENV_CODE="#ifndef ENV_H\n#define ENV_H\n\n#define PROJECT_ROOT \"$PWD/\"\n\n#endif"
    echo "$ENV_CODE" > src/env.hpp
    mkdir build

    elif [ $1 = "rmzip" ]; then    
        rm -rf ./_extern/*.zip

    else
        rm -rf ./_extern
        rm -rf ./include
        rm -rf ./src
        rm -rf ./lib
        rm -rf ./build
fi

