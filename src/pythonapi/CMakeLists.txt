SET (CXX_SRCS
   GetArgs.cc
   PythonCommands.cc
   CommandHandler.cc
   ObjectHolder.cc
   OutputStream.cc
   Interpreter.cc
)

INCLUDE_DIRECTORIES (
    ../utility
    ../pythonapi
    ../commands
    ../common_api
)

#ADD_LIBRARY (pythonapi_interpreter_py27 OBJECT ${CXX_SRCS})
#ADD_LIBRARY (pythonapi_api_py27 OBJECT ${CXX_SRCS2})
#TARGET_INCLUDE_DIRECTORIES (pythonapi_interpreter_py27 BEFORE PRIVATE ${PYTHON27_INCLUDE})
#target_compile_definitions(pythonapi_interpreter_py27 PRIVATE -DDEVSIM_MODULE_NAME=devsim_py27)


IF (PYTHON3)
#ADD_LIBRARY (pythonapi_interpreter_py36 OBJECT ${CXX_SRCS})
#TARGET_INCLUDE_DIRECTORIES (pythonapi_interpreter_py36 BEFORE PRIVATE ${PYTHON36_INCLUDE})
#target_compile_definitions(pythonapi_interpreter_py36 PRIVATE -DDEVSIM_MODULE_NAME=devsim_py36 -DPy_LIMITED_API=0x03030000)
ADD_LIBRARY (pythonapi_interpreter_py37 OBJECT ${CXX_SRCS})
TARGET_INCLUDE_DIRECTORIES (pythonapi_interpreter_py37 BEFORE PRIVATE ${PYTHON37_INCLUDE})
target_compile_definitions(pythonapi_interpreter_py37 PRIVATE -DDEVSIM_MODULE_NAME=devsim_py3 -DPy_LIMITED_API=0x03030000)
ENDIF (PYTHON3)

