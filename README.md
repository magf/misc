# misc
Miscellaneous scripts

## [gitlab_include_depends_checker.sh](gitlab_include_depends_checker.sh)

Сканирует все yml-файлы из текущего каталога, находит в них все include и делает в include-файлах отметки, откуда они включаются.

Если добавить ключ -f, --full, то отметки будут расставляться в обе стороны, оба файла. Удобно, если головной файл очень большой.

При каждом новом запуске все старые отметки удаляются и выставляются новые.

Если указан ключ -c, --clear, то будет выполнена очистка установленных меток.
