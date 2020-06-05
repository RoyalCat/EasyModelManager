## Запуск сервера API
#### Для запуска необходим установленный Docker клиент
Контейнер можно скачать по ссылке `https://yadi.sk/d/W8N07AezyhRFwg`
Для запуска сервера из Docker-контейнера, нужно выполнить следуюшие команды:
```bash
    docker load < emm-server.tar 

# для запуска в интерактивном режиме
    docker run emm-server

# или для запуска в фоновном режиме
    docker run -d emm-server
```

После этого API будет доступно по ip адаптера Doker(docker0 по умолчанию) и порту 666  

---
## Запуск Web-сервера
В папке Web-сервера в файле `/assets/assets/config/dev.json` изменить значение `apiUrl` на адрес сервера API  
Для запуска можно использовать любой веб-сервер, например:
```bash
# Для Python 3.X
    python -m http.server
# Для Python 2.X
    python -m SimpleHTTPServer
```