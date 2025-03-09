# Установка TotalCommander как файлового менеджера по умолчанию

Чтобы вернуть проводник изменить путь в скрипте на путь к проводнику

https://www.ghisler.ch/board/viewtopic.php?t=76915

Файл `reg.reg`:
```
Windows Registry Editor Version 5.00
 
 [HKEY_CLASSES_ROOT\Drive\shell]
 @="open"
 
 [HKEY_CLASSES_ROOT\Drive\shell\open]
 
 [HKEY_CLASSES_ROOT\Drive\shell\open\command]
 @="c:\\Program Files\\totalcmd\\TOTALCMD64.EXE /O \"%1\""
 
 [HKEY_CLASSES_ROOT\Directory\shell]
 @="open"
 
 [HKEY_CLASSES_ROOT\Directory\shell\open]
 
 [HKEY_CLASSES_ROOT\Directory\shell\open\command]
 @="c:\\Program Files\\totalcmd\\TOTALCMD64.EXE /O \"%1\""
```

