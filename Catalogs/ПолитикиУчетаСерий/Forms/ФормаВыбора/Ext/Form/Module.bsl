﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ИспользоватьСерии = Неопределено;
	
	Если Не Параметры.Свойство("ИспользоватьСерии", ИспользоватьСерии) Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ИспользоватьСерии Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти