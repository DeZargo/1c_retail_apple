﻿
#Область ОбработчикиСобытийФормы

&НаСервере
// Процедура - обработчик события формы ПриСозданииНаСервере
//
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("РасписаниеРегламентногоЗадания", РасписаниеРегламентногоЗадания);
	
	Если ТипЗнч(РасписаниеРегламентногоЗадания) = Тип("РасписаниеРегламентногоЗадания") Тогда
		
		УстановитьАктуальнуюНадписьПериодаПовтораНаСервере(РасписаниеРегламентногоЗадания.ПериодПовтораВТечениеДня);
		
	КонецЕсли;
	
КонецПроцедуры //ПриСозданииНаСервере()

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
// Процедура - обработчик команды ЗаписатьИЗакрыть
//
//
Процедура Применить(Команда)
	
	УстановитьРасписание();
	
	Оповестить("ОбновитьРасписание", РасписаниеРегламентногоЗадания);
	
	Закрыть();
	
КонецПроцедуры //ЗаписатьИЗакрыть()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
// Устанавливает пользовательское представление периода повтора
//
Процедура УстановитьАктуальнуюНадписьПериодаПовтораНаСервере(ЗначениеПериода)
	
	Если ЗначениеПериода = 0 Тогда
		
		ВариантыРасписаниеОбменаССайтами = НСтр("ru = 'Один раз в 30 минут'"); // Значение по-умолчанию
		
	ИначеЕсли ЗначениеПериода <= 300 Тогда
		
		ВариантыРасписаниеОбменаССайтами = НСтр("ru = 'Один раз в 5 минут'");
		
	ИначеЕсли ЗначениеПериода <= 1800 Тогда
		
		ВариантыРасписаниеОбменаССайтами = НСтр("ru = 'Один раз в 30 минут'");
		
	ИначеЕсли ЗначениеПериода <= 21600 Тогда
		
		ВариантыРасписаниеОбменаССайтами = НСтр("ru = 'Один раз в 6 часов'");
		
	ИначеЕсли ЗначениеПериода <= 43200 Тогда
		
		ВариантыРасписаниеОбменаССайтами = НСтр("ru = 'Один раз в 12 часов'");
		
	КонецЕсли;
	
КонецПроцедуры //УстановитьАктуальнуюНадписьПериодаПовтораНаСервере()

&НаКлиенте
// Функция возвращает ПериодПовтораВТечениеДня в секундах
//
Функция ПолучитьПериодПовтораВТечениеДня()
	
	ЗначенияВыбора = СоответствиеЗначенийВыбораККоличествуСекунд();
	
	ПериодПовтораВТечениеДня = ЗначенияВыбора.Получить(ВариантыРасписаниеОбменаССайтами);
	Возврат ?(ПериодПовтораВТечениеДня = Неопределено, 0, ПериодПовтораВТечениеДня);
	
КонецФункции //ПолучитьПериодПовтораВТечениеДня()

&НаКлиенте
// Функция возвращает соответствие надписей выбора к количеству секунд
// 
Функция СоответствиеЗначенийВыбораККоличествуСекунд()
	
	СоответствиеНадписей = Новый Соответствие;
	СоответствиеНадписей.Вставить(НСтр("ru = 'Один раз в 5 минут'"), 300);
	СоответствиеНадписей.Вставить(НСтр("ru = 'Один раз в 30 минут'"), 1800);
	СоответствиеНадписей.Вставить(НСтр("ru = 'Один раз в 6 часов'"), 21600);
	СоответствиеНадписей.Вставить(НСтр("ru = 'Один раз в 12 часов'"), 43200);
	
	Возврат СоответствиеНадписей;
	
КонецФункции //СоответствиеЗначенийВыбораККоличествуСекунд()

&НаКлиенте
// Заполняет значения расписания регламентного задания
//
Процедура УстановитьРасписание()
	
	Месяцы = Новый Массив;
	Месяцы.Добавить(1);
	Месяцы.Добавить(2);
	Месяцы.Добавить(3);
	Месяцы.Добавить(4);
	Месяцы.Добавить(5);
	Месяцы.Добавить(6);
	Месяцы.Добавить(7);
	Месяцы.Добавить(8);
	Месяцы.Добавить(9);
	Месяцы.Добавить(10);
	Месяцы.Добавить(11);
	Месяцы.Добавить(12);

	ДниНедели = Новый Массив;
	ДниНедели.Добавить(1);
	ДниНедели.Добавить(2);
	ДниНедели.Добавить(3);
	ДниНедели.Добавить(4);
	ДниНедели.Добавить(5);
	ДниНедели.Добавить(6);
	ДниНедели.Добавить(7);
	
	ПериодПовтораВТечениеДня = ПолучитьПериодПовтораВТечениеДня();
	
	Если ПериодПовтораВТечениеДня > 0 Тогда
		
		Расписание = Новый РасписаниеРегламентногоЗадания;
		Расписание.Месяцы					= Месяцы;
		Расписание.ДниНедели				= ДниНедели;
		Расписание.ПериодПовтораВТечениеДня = ПериодПовтораВТечениеДня; // секунды
		Расписание.ПериодПовтораДней		= 1; // каждый день
		
		РасписаниеРегламентногоЗадания = Расписание;
		
	КонецЕсли;
	
КонецПроцедуры //УстановитьРасписание()

#КонецОбласти