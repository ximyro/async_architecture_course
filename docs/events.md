# Event streaming

## Создание задачи

Actor: User  
Command: Create task  
Data: Task + user public id  
Event: Tasks.Created  

## Назначение стоимости задачи

Actor: Event Tasks.Created  
Command: Calculate task amounts  
Data: task id  
Event: Tasks.AmountsCalculated  

## Сохранение стоимости задачи

Actor: Event Tasks.AmountsCalculated  
Command: UpdateTaskAmounts  
Data: task fee + task amount  
Event: Tasks.ReadyForAssign  

## Назначение задачи для всех

Actor: User(manager)  
Command: Assign tasks  
Data: user public id  
Event: Tasks.Assigned  

## Задача звершена

Actor: User  
Command: Task completed  
Data: user public id + task id  
Event: Tasks.Completed  

## Снять деньги с баланса пользователя

Actor: Event Tasks.Assigned  
Command: Charge User Balace  
Data: user public id + user balance + task fee  
Event: Users.BalanceCharged  

## Создать аудит запись изменения баланса

Actor: Users.BalanceCharged  
Command: Create audit record  
Data: user_id + balance changes  
Event: ???  

## Увеличить значение, сколько заработали менеджеры

Actor: Tasks.Assigned  
Command: Increment the value of how many managers earn  
Data: task fee  
Event: Managers.BalaceChanged  

## Уменьшить значение, сколько заработали менедждеры

Actor: Tasks.Completed  
Command: Decrease the value of how many managers earn  
Data: task amount  
Event: Managers.BalaceChanged

## Увеличить значение того, сколько пользователь заработал за день

Actor: Tasks.Completed  
Command: Increment how many user earn  
Data: user public id + task id + task amount  
Event: Users.BalaceChanged

## Увеличить значение, сколько попугов ушли в минус

Actor: Tasks.Assigned  
Command: Increment the value of how many managers earn  
Data: task amount  
Event: ???

## Уменьшить значение того, сколько попутов ушли в минус

Actor: Tasks.Completed  
Command: Decrease how many popugs have negative balance  
Data: user public id + task id + task amount  
Event: ????  

## Расчитать пользователей за день

Actor: Cron job  
Command: Pay the user the total amount per day  
Data: ???  
Event: Users.DailyPaidAmount  

## Отправить письмо

Actor: Event Users.DailyPaidAmount  
Command: Send email  
Data: user email + email data  
Event: ?????  

## Выставить баланс пользователя в 0

Actor: Event Users.DailyPaidAmount  
Command: Set User balance = 0  
Data: user id
Event: ?????  

## Расчитать самую дорогую задачу за день

Actor: Tasks.Completed  
Command: Check || change the most expensive task during the day  
Data: task amount  
Event: Analytics.ExpensiveTaskForDay

## Расчитать самую дорогую задачу за неделю

Actor: Analytics.ExpensiveTaskForDay  
Command: Check || change the most expensive task during the week  
Data: task amount  
Event: Analytics.ExpensiveTaskForWeek  

## Расчитать самую дорогую задачу за месяц

Actor: Tasks.Completed  
Command: Check || change the most expensive task during the month  
Data: task amount  
Event: ???  

## Скопировать значение того, сколько заработали менеджеры

Actor: Managers.BalaceChanged  
Command: Apply the difference + save for UI  
Data: maangers balance changes + date  
Event: ???  
