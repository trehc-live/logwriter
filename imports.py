import subprocess

# Открываем файл с названиями библиотек
with open('libraries.txt', 'r') as file:
    libraries = file.readlines()

# Устанавливаем каждую библиотеку
for library in libraries:
    try:
        subprocess.check_call(['pip', 'install', library.strip()])
        print(f'{library.strip()} успешно установлена')
    except subprocess.CalledProcessError as e:
        print(f'Ошибка при установке {library.strip()}: {e}')
