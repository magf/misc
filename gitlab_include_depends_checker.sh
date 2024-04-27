#!/bin/bash
# Сканирует все yml-файлы из текущего каталога, находит в них все include и делает в include-файлах отметки, откуда они включаются.
# Если добавить ключ -f, --full, то отметки будут расставляться в обе стороны, оба файла. Удобно, если головной файл очень большой.
# При каждом новом запуске все старые отметки удаляются и выставляются новые.
# Если указан ключ -c, --clear, то будет выполнена очистка установленных меток.

export DEP_PREFIX='# CI-DEPS ' # Префикс, по которому будет определяться принадлежность
export ARG=$1

# Удаляем все зависимости во всех файлах. Если был ключ очистки, то заканчиваем работу
find . -type f -name '*.yml' -exec sed -i "/^$DEP_PREFIX/d" {} \;
[[ "$ARG" == "-c" || "$ARG" == "--clear" ]] && exit 0

# Функция обновления зависимостей
function update () {
    if ! grep -q "$DEP_PREFIX" $1; then sed -i "1i $DEP_PREFIX Обновлено $(date)" $1; fi
    sed -i -E "0,\|^($DEP_PREFIX.+)$|s||\1\n$DEP_PREFIX $2|" $1
    [ $? -eq 0 ] && echo -e "\t\e[32mUpdted:\e[m\t$1"
}
export -f update

# Функция поиска зависимостей
function parsing () {
    unset file
    git check-ignore -q "$1" || file=$1
    [ -z "$file" ] && exit

    echo -e "\e[31mParsing\e[m $file"

    includes=$(yq '.include[].local // ""' $file)
    if [ -n "$includes" ]; then
        for include in ${includes[*]}; do
        include=${include##/}
        echo -e "\t\e[34mFound:\e[m\t$include"
        update $include "ссылка из $file"
        [[ "$ARG" == "-f" || "$ARG" == "--full" ]] && update $file "ссылается на $include"
        done
    fi
}
export -f parsing

# Вся программа =)
find $DIR -type f -name '*.yml' -exec bash -c 'parsing $0' {} \;
