#!/bin/bash

# Скрипт для выбора файлов через системный диалог
# Поддерживает zenity (GTK) и kdialog (KDE)

HERE="$(dirname "$(readlink -f "${0}")")"

# Функция для выбора файла через zenity
pick_file_zenity() {
    local title="$1"
    local filter="$2"
    zenity --file-selection --title="$title" --file-filter="$filter" 2>/dev/null
}

# Функция для выбора файла через kdialog
pick_file_kdialog() {
    local title="$1"
    local filter="$2"
    kdialog --getopenfilename --title "$title" "$filter" 2>/dev/null
}

# Функция для выбора директории через zenity
pick_dir_zenity() {
    local title="$1"
    zenity --file-selection --directory --title="$title" 2>/dev/null
}

# Функция для выбора директории через kdialog
pick_dir_kdialog() {
    local title="$1"
    kdialog --getexistingdirectory --title "$title" 2>/dev/null
}

# Определяем доступный диалог
if command -v zenity >/dev/null 2>&1; then
    pick_file() { pick_file_zenity "$@"; }
    pick_dir() { pick_dir_zenity "$@"; }
elif command -v kdialog >/dev/null 2>&1; then
    pick_file() { pick_file_kdialog "$@"; }
    pick_dir() { pick_dir_kdialog "$@"; }
else
    echo "Ошибка: не найден zenity или kdialog для диалога выбора файлов"
    echo "Установите zenity: sudo dnf install zenity"
    echo "Или kdialog: sudo dnf install kde-runtime"
    exit 1
fi

# Выбираем файлы
echo "Выберите исполняемый файл (il2cpp)..."
executable_file=$(pick_file "Выберите исполняемый файл il2cpp" "*.exe *.so *.dll")

if [ -z "$executable_file" ]; then
    echo "Файл не выбран"
    exit 1
fi

echo "Выберите файл global-metadata.dat..."
metadata_file=$(pick_file "Выберите global-metadata.dat" "global-metadata.dat")

if [ -z "$metadata_file" ]; then
    echo "Файл не выбран"
    exit 1
fi

echo "Выберите выходную директорию..."
output_dir=$(pick_dir "Выберите выходную директорию")

if [ -z "$output_dir" ]; then
    echo "Директория не выбрана"
    exit 1
fi

# Запускаем Il2CppDumper с выбранными файлами
export PATH="${HERE}/usr/bin:${PATH}"
export DOTNET_ROOT="${HERE}/usr/bin"

exec "${HERE}/usr/bin/Il2CppDumper" "$executable_file" "$metadata_file" "$output_dir"
