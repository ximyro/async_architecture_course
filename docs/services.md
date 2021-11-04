# Сервисы

## Auth

- Хранит пользователей
- Хранит менеджеро
- Хранит роль
- Решает кому и куда можно

## Tasker

- Создание/Завершение задачи
- Назначение задач

UI

- Создание/Завершение задачи
- Назначение задача

## Pricing

- Назначение стоимости задачи
- Назначение того, сколько надо снять с пользователя

## AccountingService

Аггрегирует события из Tasks/Pricing для проведения операций над счетом пользователя. Ему не важно откуда пришла задача и кто назначил цену

- Хранение счета пользователя
- Хранение аудит лого для счета пользователя
- Снятие денег со счета пользователя при назначении
- Пополнение баланс пользователя после завершения задачи
- Отправка уведомлений пользователю
- Обнуление баланса в полночь

UI

- Счет + аудит по счету
- Стоимость таски  + аудит по начислениям/снятиям для таски
- Кол-во заработанных менеджментом за день денег
- Хранит информацию из сервиса Analytics для предоставления

## Analytics

UI + логика

- Самая дорогая задача за день/неделю/месяц
- Сколько менеджеры заработали за сегодня
- Сколько попугов ушли в минус