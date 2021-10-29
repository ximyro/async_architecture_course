# Диаграммы

## High level diagram

Take a look at [it]("High-level architecture.png")

## Tasker

что-то, что отвечает за создание и завершение тасок. Так же в этом месте может назначаться сумма для задачи, но это открытый вопрос.

Events

- Tasks.Created
- Tasks.Assigned
- Tasks.Completed

Обрабатывает событие Tasks.Calculated

## UI

TasksUI, AccoutingUI, AnalystsUI - Дашборды

## Autheticator

Модуль отвечает за доступ пользователей к различным частям системы.
Хранит информацию о пользователях.

Events

- Users.logined

## EndDayProcessor

Расчитывает в конце дня пользователей у которых положительный баланс, отправляем им уведомление, генерирует событие
Он отправляет события о том, что пользователя расчитали и т.д

- Users.Invoicing.EndOfDay

## Accounting

Хранит и предоставляет интерфейс для получения следующих даннных

- Сколько заработал пользователь за сегодня
- Детализацию по счету пользователя
- Сколько заработал топ менеджмент в деньгах

    ```bash
    (sum(completed task amount) + sum(created task fee)) * -1
    ```

- Считает сколько стоит задача

Events

Обрабатывает

- Tasks.Created

Создает

- Tasks.Calculated

## Auditor

Принимает и хранит информацию обо всех audit message logs.

Принимает сигналы о том, что произошло с задачей.

- Создана
- Завершена
- Назначен исполнитель
- Пользователь расчитан за день

## Analysts

Хранит и предоставляет интерфейс для получения следующих данных:

- Самая дорогая задача
- Сколько заработал том менеджмент за сегодня: сколько попугов ушло в минус

Events

Обрабатыает

- Tasks.Completed
- Tasks.Assigned

## Модель данных

User -> Auth  
|  
|  
Account -> Details -> Each action log + Total amount for a day  -> How many managers earn  
|  
|  
Tasks  -> Details -> Cost  
|  
|  
Analytics -> Max task amount per day -> How many managers earn in count
