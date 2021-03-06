# Проектное задание по курсу DevOPS


## Архитектура приложения
Приложение состоит из 4-х микросервисов, каждый из которых находиться в своем Docker контейнере. 

Микросервисы с описанием:
  - rabbitmq (сервис очередей);
  - mongo_db (база данных);
  - search_engine_crawler (парсер страниц);
  - search_engine_ui (web интерфейс пользователя);

Production сервер используется 1 (но возможно задать необходимое количество в terraform, поправив некоторые дашборды мониторинга и джобы prometheus'a).


## Инфраструктура
Инфраструктура разворачивается в Google Cloud Platform с помощью terraform и ansible.
В инфраструктуре используются следующие инстансы:
- gitlab-ci;
- gitlab-runners (инстанс для раннеров gitlab-ci);
- stage (динамический инстанс, создается при развертывании stage окружения и проверки работы приожения, потом он удаляется);
- production
- monitoring (инстанс для служб мониторинга, таких как prometheus, alertmanager, grafana). 


## Схема работы pipeline
Созданы 3 дирректории (каждая из которых в gitlab-ci должна быть в отдельном репозитарии):
- search_engine_crawler
- search_engine_ui
- search_engine_infra

В первых 2-х репозитариях храниться код соответствующего микросервиса. В последнем - инфраструктурный код. 

Принцип действия моего pipeline такой (по порядку):
- делается пуш в любой из репозитариев микросервиса в ветку отличную от master;
- прогоняются автоматические тесты;
- если тесты проходят нормально - то можно сделать Merge Request на слияние в ветку master;
- просматривается Merge Request, делается CodeReview. Если все хорошо - делаем слияние в ветку master;
- после слияния в ветку мастер начинается билд докер-образа и его пуш на докерхаб, добавляется тег с названием ветки и номером билда;
- после успешного билда срабатывает тригер и запускается pipeline репозитория search_engine_infra, в который передается название образа, который был создан;
- создается сервер stage с использованим docker-machine;
- разворачивается приложение (4 контейнера), делается Review;
- stage сервер удаляется и можно выполнить release, если все нормально. При release создается докер образ измененного микросервиса с тегом latest и master-pipeline_number;
- Далее можно уже выполнить deploy на prod (в gitlab-ci данный процесс запускается вручную по кнопке). 


## Как запустить

## Развертывание инфраструктуры (terraform + ansible)
### 1. Создание инстансов. (!!! Первый старт с нуля !!!) Действия, необходимые для развертывания инфраструктуры проекта.
- Предварительно необходимо установить gcloud и авторизоваться: 
  - `gcloud auth login`
  - `gcloud auth application-default login`
  - `gcloud config set account your_login@gmail.com`
  - `gcloud config set project your_project`
- Далее необходимо установить terraform, ссылка на мануал: https://www.terraform.io/intro/getting-started/install.html ;
- Сгенерировать и положить ssh ключи otusproj по пути `search_engine_infra/ssh/otusproj/`;
- Скопировать файл `search_engine_infra/terraform/terraform.tfvars.example` в `search_engine_infra/terraform/terraform.tfvars` и файл `search_engine_infra/terraform/prod/terraform.tfvars.example` в `search_engine_infra/terraform/prod/terraform.tfvars`;
- Внести изменения в конфигурационный файл terraform `search_engine_infra/terraform/prod/terraform.tfvars`, изменив значение переменной `gitlab_new_disk` на "1", после успешного развертывания вернуть обратно на "0"; 
- Для развертывания инфраструктуры, необходимо, находясь в директории `search_engine_infra/terraform/`, выполнить команды `terraform init` и `terraform apply` - создадутся необходимые бакеты;
- Далее из директории `search_engine_infra/terraform/prod/` выполнить команды `terraform init` и `terraform apply` - развернуться необходимые инстансы; P.S. если вдруг при выполнении `terraform apply` возникла ошибка (такое иногда бывает, если сеть еще не успела развернуться, а инстансы уже начали разворачиваться) - то необходимо выполнить команду `terraform apply` еще раз. К сожалению terraform пока не позволяет прописывать зависимости модулей.
- После успешного развертывания будет выведен ip адрес хоста gitlab-ci. Его необходимо прописать в переменные в файл search_engine_infra/ansible/environments/prod/group_vars/gitlab-ci в переменную `ext_ip_addr`.


### 2. Развертывание Gitlab-ci, Gitlab-ci Runners и запуск Pipeline.
- Для успешного запуска необходимо предварительно создать образы микросервисов search_engine_ui и search_engine_crawler и запушить их с тегом latest;
- Установить Ansible;
- Создадим service account в GCP и положим сгенерированный файлик в формате json в директорию `search_engine_infra/ansible/`, переименуем название файла в `credentials.json`;
- Укажем необходимого пользователя в конфигурационном файле ansible по пути `search_engine_infra/ansible/ansible.cfg` (строка 3);
- Укажем необходимый проект и email service account GCP в файле search_engine_infra/ansible/environments/prod/gce.ini для работы dynamic inventory;
- Проверить доступность всех узлов, выполнив команду `ansible all -m ping` из директории `search_engine_infra/ansible/`
- Установить Gitlab-ci. Последовательно выполнить команды, находясь в директории `search_engine_infra/ansible/`: 
  - `ansible-galaxy install -r environments/prod/requirements.yml` - установка необходимых ролей;
  - `ansible-playbook playbooks/install-gitlab-ci.yml -l gitlab-ci` - установка и запуск gitlab-ci;
- Прописать в /etc/hosts на ПК с которого будет заходить на gitlab-ci `<ip_of_gitlab-ci> gitlab-ci`
- Перейти по адресу http://gitlab-ci и задать пароль для пользователя root;
- Отключить регистрацию новых пользователей в настройках gitlab-ci;
- Создать группу search_engine, и в ней 3 проекта: search_engine_crawler, search_engine_ui, search_engine_infra;
- Добавить раннеры. Для этого: 
  - Зайти в любой проект в Settings -> CI/CD -> Runners settings;
  - Скопировать токен раннера и вставить этот токен и ip адрес giltab сервера в переменные в файл `search_engine_infra/ansible/files/register-gitlab-runners.sh` (строка 4 и 5);
  - Выполнить плейбук: `ansible-playbook playbooks/register-runners.yml -l gitlab-runners`;
  - Активировать зарегистрированные раннеры для всех 3-х проектов, зайдя в каждом проекте в Settings -> CI/CD -> Runners settings и нажав кнопку "Enable for this project" напротив раннера;
- Добавить триггеры. Для этого:
  - Зайти в проект search_engine_infra в Settings -> CI/CD -> Pipeline triggers и добавить триггер `DEPLOY_TRIGGER`;
  - Установить его значение в переменные в файлы .gitlab-ci.yml проектов search_engine_ui и search_engine_crawler (в разделе `.auto_devops: &auto_devops` строчка `export DEPLOY_TRIGGER=`);
  - Исправить путь к проекту в коде самого тригера в тех же файлах и проектах (файлы .gitlab-ci.yml, проекты search_engine_ui и search_engine_crawler). Код триггера находиться в самом низу раздела `.auto_devops: &auto_devops` и выглядит примерно так: 
```
function trigger_deploy() {
    apk add -U curl 
    curl -X POST -F token=${DEPLOY_TRIGGER} -F ref=master -F "variables[DOCKER_IMAGE_HUB_UI_EXT]=${DOCKER_IMAGE_HUB}" http://35.195.161.57/api/v4/projects/3/trigger/pipeline
  }
```
- В web-интерфейсе gitlab-ci добавить переменные для DockerHub (для возможности пуша образов). Названия переменных должны быть `DOCKER_HUB_LOGIN` и `DOCKER_HUB_PASS`. Добавить их необходимо в проекты **search_engine_ui** и **search_engine_crawler**, пройдя Settings -> CI/CD -> Variables; 
- Создать переменную с названием `DEPLOY_SERVER_PRIVATE_KEY` в проекте **search_engine_infra** с содержмимым приватного ранее сгенерированного ssh-ключа, пройдя Settings -> CI/CD -> Variables;
- Создать переменную с названием `CREDENTIALS_JSON` в проект search_engine_infra с содержмимым файла service account GCP `credentials.json`, пройдя Settings -> CI/CD -> Variables;
- Если prod окружение запускается впервые - то выполнить плейбук `ansible-playbook playbooks/install-prod.yml -l tag_production`из директории search_engine_infra/ansible/, предварительно задав переменную `docker_hub_login` (имя пользователя на Docker HUB) в файлах `06-prod-run-search_engine-crawler.yml` и `07-prod-run-search_engine-ui.yml`; 
- Запушить каждую дирректории **search_engine_crawler**, **search_engine_ui** и **search_engine_infra** в соответствующий проекты;


### 3. Развертывание мониторинга
Для развертывания системы мониторинга необходимо:
- Скопировать EXAMPLE-файл и исправить значения переменных на необходимые значения, файл `search_engine_infra/ansible/environments/prod/group_vars/tag_monitoring`. Описание переменных, которые необходимо задать:
  - `prod_host` - внутренний ip адрес инстанса production;
  - `grafana_pass` - пароль для пользователя admin для GRAFANA;
- Скопировать EXAMPLE-файл и задать значения переменных для алертинга, файл `search_engine_infra/ansible/files/alertmanager_config.yml`. Описание переменных:
  - `slack_api_url` - Webhook URL для необходимого окружения в slack;
  - `channel` - канал в slack, куда необходимо слать уведомления;
  - `smtp_from` - email адрес, от имени которого необходимо отправлять уведомление (необходимо раскомментировать для email уведомлений);
  - `smtp_smarthost` - SMTP сервер и порт;
  - `smtp_auth_username` - имя пользователя для авторизации отправки email;
  - `smtp_auth_identity` - идентификатор (обычно такой же как и имя пользователя для авторизации);
  - `smtp_auth_password` - пароль;
  - `to` - email, куда будет отправляться уведомление;
- Выполнить плейбук Ansible `ansible-playbook playbooks/install-monitoring.yml -l tag_monitoring` находясь в директории `search_engine_infra/ansible/`;
- Выполнить действия в GRAFANA:
  - Зайти в web-интерфейс Grafana по адресу <IP_MONITORING_INSTANCE>:3000 с учетными данными, которые ранее задали в файле `search_engine_infra/ansible/environments/prod/group_vars/tag_monitoring`;
  - Указать источник данных prometheus, URL `http://prometheus:9090`;
  - Выполнить импорт дашбордов из директории `search_engine_infra/monitoring/grafana_dashboards/`;


### 4. Развертывание логгирования
В процессе...



## Как проверить
### Проверка PipeLine:
- Создаем новую ветку (например dev) в репозитарии любого из микросервисов (search_engine_ui и search_engine_crawler) - `git checkout -b dev`;
- Вностим изменения;
- Делаем пуш в репозитарий;
- Проверяем что запускается job тестирования;
- Делаем merge request в ветку мастер, проверяем код и мержим;
- Проверяем что запустился job с созданием docker образа и его пуша на docker hub;
- Проверяем, что после успешного завершения предыдущего джоба автоматически запускается pipeline проекта search_engine_infra;
- Поочередно проходим все джобы проекта search_engine_infra;


### Проверка алертинга:
- Настроен алертинг на недоступность контейнеров на инстансе prod, для проверки - необходимо остановить любой контейнер. Должно придти уведомление в указанный slack-канал.
