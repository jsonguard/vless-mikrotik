# vless-mikrotik

Готовый образ для запуска VLESS-туннеля на Mikrokik.

Решение построено на оснвое приложения sing-box и представляет собой докер-образ с приложением и подготовленной конфигурацией для запуска в контейнере на устройстве Mokrotik

Приннцип работы: 

При запуске контейнер генерирует рантайм-конфигурацию на основе значений из переменных окружения, затем запускает процесс sing-box. 

Он в свою очередь читает этот конфигурационный файл и переходит на работу в режиме TUN (прохрачный прокси). 

Начиная с этого момента мы можем свободно маршрутизировать TCP/UDP пакеты на адрес контейнера, где sing-box получит их и направит через VLESS-туннель в сервер назначения

Требования:
- Уже настроенный сервер с серверной частью VLESS, например sing-box или xray-core
- Mikrotik с 64-битным процессором ARN
- Вставленная, размеченная, отформатированная и смонтированная флешка для хранения данных контейнеров
- Установленный пакет `container` и соответствующие разрешения в системе для работы контейнеров
    ```sh
    /system/device-mode/update container=yes 
    ```



Docker Hub: https://hub.docker.com/repository/docker/jsonguard/vless-mikrotik

Sing-box: https://github.com/SagerNet/sing-box

## Настройка для запуска контейнера

1. Создадим новый бридж и назначим его шлюзом для контейнерной сети
    ```sh
    /interface/bridge/add name=containers
    /ip/address/add address=172.17.0.1/24 interface=containers
    ```
1. Создадим виртуальный интерфейс для работы контейнера и назначим ему адрес
    ```sh
    /interface/veth/add name=vless address=172.17.0.2/24 gateway=172.17.0.1
    ```
    Этот адрес будет адерсом вашего контейнера, куда мы будем маршрутизировать трафик
1. Добавим интерфейс контейнера в созданный ранее бридж
    ```sh
    /interface/bridge/port add bridge=containers interface=vless
    ```
1. Настроим NAT для исходящего из контейнерной сети трафика
    ```sh
    /ip/firewall/nat/add chain=srcnat action=masquerade src-address=172.17.0.0/24
    ```
1. Установим зеркало для скачивания образов и временный каталог для извлечения
    ```sh
    /container/config/set registry-url=https://registry-1.docker.io tmpdir=/usb1-part1/containers/tmp layer-dir=/usb1-part1/containers/layers ram-high=0
    ```
    Установка `ram-high` крайне важна, без этого контейнеры не будут работать после перезагрукзи устройства -- особенность работы контейнеров в RouterOS
1. Зададим конфигурацию для работы контейнера через переменные окружения
    ```sh
    /container envs
    add name=vless key=REMOTE_ADDRESS value=XXX.vless-server.com
    add name=vless key=USER_ID value=XXXX-XXXX-XXXX-XXXX
    add name=vless key=STREAM_PUBLIC_KEY value=XXXX
    add name=vless key=STREAM_SERVER_NAME value=yahoo.com
    add name=vless key=STREAM_SHORT_ID value=XXXX
    ```
1. Добавим контейнер
    ```sh
    /container/add remote-image="jsonguard/vless-mikrotik:1.11.13-singbox" envlist=vless interface=vless logging=yes root-dir=usb1-part1/containers/vless-mikrotik start-on-boot=yes
    ```
1. Дождемся, пока образ скачается и контейнер будет готов к запуску. Проверим логи
    ```sh
    /log print
    ```
    Здесь можно следуить за ходом загрузки и распаковки образа. По окончанию, контейнер должен перейти в статус `stopped`. Проверим в списке контейнеров
    ```sh
    /container/print
    ```
1. Запустим контейнер
    ```sh
    /container/start 0
    ```
    За ходом запуска можно следить в логах
1. Используя маршруты, направим трафик в туннель
    ```sh
    /ip/route/add dst-address=X.X.X.X gateway=172.17.0.2 check-gateway=ping

## Переменные окружения для конфигурации

Обязательные:
```
/container envs
add name=vless key=REMOTE_ADDRESS value=XXX.vless-server.com
add name=vless key=USER_ID value=XXXX-XXXX-XXXX-XXXX
add name=vless key=STREAM_PUBLIC_KEY value=XXXX
add name=vless key=STREAM_SERVER_NAME value=yahoo.com
add name=vless key=STREAM_SHORT_ID value=XXXX
```

Дополнительные:
```
/container envs
add name=vless key=LOG_LEVEL value=warn

add name=vless key=REMOTE_PORT value=443

add name=vless key=USER_FLOW value=xtls-rprx-vision
add name=vless key=STREAM_FINGERPRINT value=chrome
add name=vless key=TUN_INTERNAL_NETWORK value="172.16.255.1/24"
```