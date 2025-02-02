﻿
#Область ПрограммныйИнтерфейс

// Заполняет структуру выполнения операции внесение ДС в кассу ККМ.
// 
Функция ПараметрыВыполненияОперацииВнесениеДенег() Экспорт; 
	
	Результат = Новый Структура();
	Результат.Вставить("Результат", Ложь);
	Результат.Вставить("СуммаВнесения");
	Результат.Вставить("РКО");
	Результат.Вставить("КассаККМ");
	Результат.Вставить("УникальныйИдентификатор");
	Результат.Вставить("ДокументВнесениеДС", Неопределено);
	Результат.Вставить("БезВыводаСообщений", Ложь);
	Результат.Вставить("ОшибкаТранзакции"  , Неопределено);
	Результат.Вставить("ТекстСообщения"    ,  "");
	Возврат Результат;
	
КонецФункции

// Процедура - выполняет внесение ДС в кассу ККМ, отправляет команду внесения на ФР и
// создает документ Внесение ДС в кассу ККМ.
//
Процедура НачатьВнесениеДенег(ОповещениеПриЗавершении, ПараметрыВыполнения) Экспорт
	
	ПараметрыКассыККМ = ЗначениеНастроекВызовСервера.ПолучитьПараметрыКассыККМ(ПараметрыВыполнения.КассаККМ);
	ИдентификаторУстройства = ПараметрыКассыККМ.ИдентификаторУстройства;
	ИспользоватьПодключаемоеОборудование = ЗначениеНастроекВызовСервера.ИспользоватьПодключаемоеОборудование();
	
	Если НЕ ИспользоватьПодключаемоеОборудование ИЛИ ПараметрыКассыККМ.ИспользоватьБезПодключенияОборудования Тогда
		Попытка
			ПараметрыВыполнения.ДокументВнесениеДС = ДенежныеСредстваВызовСервера.СоздатьДокументВнесениеДенежныхСредствВКассуККМ(ПараметрыВыполнения.СуммаВнесения, ПараметрыВыполнения.РКО, ПараметрыВыполнения.КассаККМ);
			ПараметрыВыполнения.Результат = Истина;
		Исключение
			ПараметрыВыполнения.Результат = Ложь;
		КонецПопытки;
		ВыполнитьОбработкуОповещения(ОповещениеПриЗавершении, ПараметрыВыполнения);
		
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеНастроекВызовСервера.ИспользоватьПодключаемоеОборудование() Тогда
		Попытка
			ПараметрыВыполнения.ДокументВнесениеДС = ДенежныеСредстваВызовСервера.СоздатьДокументВнесениеДенежныхСредствВКассуККМ(ПараметрыВыполнения.СуммаВнесения, 
				ПараметрыВыполнения.РКО, ПараметрыВыполнения.КассаККМ);
			ПараметрыВыполнения.Результат = Истина;
		Исключение
			ПараметрыВыполнения.Результат = Ложь;
		КонецПопытки;
		ВыполнитьОбработкуОповещения(ОповещениеПриЗавершении, ПараметрыВыполнения);
		Возврат; 
	Иначе
		Если ИдентификаторУстройства <> Неопределено Тогда
			ПараметрыВыполнения.Вставить("ОповещениеПриЗавершении", ОповещениеПриЗавершении);
			ПараметрыОперации = Новый Структура("ТипИнкассации, Сумма", 1, ПараметрыВыполнения.СуммаВнесения);
			Оповещение = Новый ОписаниеОповещения("НачатьВнесениеДенегЗавершение", ЭтотОбъект, ПараметрыВыполнения);
			МенеджерОборудованияКлиент.НачатьИнкассациюНаФискальномУстройстве(Оповещение, ПараметрыВыполнения.УникальныйИдентификатор, ПараметрыОперации, ИдентификаторУстройства);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры 

// Завершение процедуры НачатьВнесениеДенег
//
Процедура НачатьВнесениеДенегЗавершение(РезультатВыполнения, ПараметрыВыполнения) Экспорт
	
	Если РезультатВыполнения.Результат Тогда
		Попытка
			ПараметрыВыполнения.ДокументВнесениеДС = ДенежныеСредстваВызовСервера.СоздатьДокументВнесениеДенежныхСредствВКассуККМ(ПараметрыВыполнения.СуммаВнесения, 
				ПараметрыВыполнения.РКО, ПараметрыВыполнения.КассаККМ);
			ПараметрыВыполнения.Результат = Истина;
		Исключение
			ПараметрыВыполнения.Результат = Ложь;
		КонецПопытки;
		ВыполнитьОбработкуОповещения(ПараметрыВыполнения.ОповещениеПриЗавершении, ПараметрыВыполнения);
		Возврат; 
	Иначе
		ТекстСообщения = НСтр("ru = 'При выполнении операции произошла ошибка.
			                        |Чек не напечатан на фискальном устройстве.
			                        |Дополнительное описание: %ДополнительноеОписание%'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДополнительноеОписание%", РезультатВыполнения.ОписаниеОшибки);
		
		Если ПараметрыВыполнения.БезВыводаСообщений Тогда 
			ПараметрыВыполнения.ТекстСообщения = ТекстСообщения;
		Иначе
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		КонецЕсли;
		
		ПараметрыВыполнения.Результат = Ложь;
		ВыполнитьОбработкуОповещения(ПараметрыВыполнения.ОповещениеПриЗавершении, ПараметрыВыполнения);
	КонецЕсли;
	
КонецПроцедуры

// Заполняет структуру выполнения операции внесение ДС в кассу ККМ.
// 
Функция ПараметрыВыполненияОперацииВыемкаДенег() Экспорт
	
	Результат = Новый Структура();
	Результат.Вставить("Результат", Ложь);
	Результат.Вставить("ИзымаемаяСумма");
	Результат.Вставить("КассаККМ");
	Результат.Вставить("УникальныйИдентификатор");
	Результат.Вставить("ДокументВыемка", Неопределено);
	Результат.Вставить("СсылкаНаОтчет" , Неопределено);
	Результат.Вставить("БезВыводаСообщений", Ложь);
	Результат.Вставить("ОшибкаТранзакции", Неопределено);
	Результат.Вставить("ДополнительныеПараметры", Неопределено);
	Результат.Вставить("ТекстСообщения" ,  "");
	Возврат Результат;
	
КонецФункции

// Процедура - выполняет выемку ДС из кассу ККМ, отправляет команду выемки на ФР и
// создает документ Выемка ДС из кассы  ККМ.
//
Процедура НачатьВыемкуДенег(ОповещениеПриЗавершении, ПараметрыВыполнения) Экспорт
	
	ПараметрыКассыККМ = ЗначениеНастроекВызовСервера.ПолучитьПараметрыКассыККМ(ПараметрыВыполнения.КассаККМ);
	ИдентификаторУстройства = ПараметрыКассыККМ.ИдентификаторУстройства;
	ИспользоватьПодключаемоеОборудование = ЗначениеНастроекВызовСервера.ИспользоватьПодключаемоеОборудование();
	
	ЗакрытьБезZОтчета = Ложь;
	Если ПараметрыВыполнения.Свойство("ЗакрытьБезZОтчета") Тогда
		ЗакрытьБезZОтчета = Истина;
	КонецЕсли;
	
	Если НЕ ИспользоватьПодключаемоеОборудование ИЛИ ПараметрыКассыККМ.ИспользоватьБезПодключенияОборудования ИЛИ ЗакрытьБезZОтчета Тогда
		
		Отказ = Ложь;
		ПараметрыВыполнения.ДокументВыемка = ДенежныеСредстваВызовСервера.СоздатьДокументВыемкаДенежныхСредствИзКассыККМ(
			Отказ, ПараметрыВыполнения.ИзымаемаяСумма,
			ПараметрыВыполнения.КассаККМ, ПараметрыВыполнения.СсылкаНаОтчет, ПараметрыВыполнения.ДополнительныеПараметры
		);
		
		Если Отказ Тогда
			ПараметрыВыполнения.Результат = Ложь;
		Иначе
			ПараметрыВыполнения.Результат = Истина;
		КонецЕсли;
		
		ВыполнитьОбработкуОповещения(ОповещениеПриЗавершении, ПараметрыВыполнения);
		Возврат;
		
	КонецЕсли;
	
	Если НЕ ЗначениеНастроекВызовСервера.ИспользоватьПодключаемоеОборудование() Тогда
		
		Отказ = Ложь;
		ПараметрыВыполнения.ДокументВыемка = ДенежныеСредстваВызовСервера.СоздатьДокументВыемкаДенежныхСредствИзКассыККМ(
			Отказ, ПараметрыВыполнения.ИзымаемаяСумма,
			ПараметрыВыполнения.КассаККМ, ПараметрыВыполнения.СсылкаНаОтчет, ПараметрыВыполнения.ДополнительныеПараметры
		);
		
		Если Отказ Тогда
			ПараметрыВыполнения.Результат = Ложь;
		Иначе
			ПараметрыВыполнения.Результат = Истина;
		КонецЕсли;
		
		ВыполнитьОбработкуОповещения(ОповещениеПриЗавершении, ПараметрыВыполнения);
		Возврат;
		
	Иначе
		Если ИдентификаторУстройства <> Неопределено Тогда
			ПараметрыВыполнения.Вставить("ОповещениеПриЗавершении", ОповещениеПриЗавершении);
			ПараметрыОперации = Новый Структура("ТипИнкассации, Сумма", 0, ПараметрыВыполнения.ИзымаемаяСумма);
			
			Оповещение = Новый ОписаниеОповещения("НачатьВыемкуДенегЗавершение", ЭтотОбъект, ПараметрыВыполнения);
			МенеджерОборудованияКлиент.НачатьИнкассациюНаФискальномУстройстве(Оповещение, ПараметрыВыполнения.УникальныйИдентификатор, ПараметрыОперации, ИдентификаторУстройства);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры 

// Завершение процедуры НачатьВыемкуДенег
//
Процедура НачатьВыемкуДенегЗавершение(РезультатВыполнения, ПараметрыВыполнения) Экспорт
	
	Если РезультатВыполнения.Результат Тогда
		
		Отказ = Ложь;
		ПараметрыВыполнения.ДокументВыемка = ДенежныеСредстваВызовСервера.СоздатьДокументВыемкаДенежныхСредствИзКассыККМ(
			Отказ, ПараметрыВыполнения.ИзымаемаяСумма, 
			ПараметрыВыполнения.КассаККМ, ПараметрыВыполнения.СсылкаНаОтчет, ПараметрыВыполнения.ДополнительныеПараметры
		);
		
		Если Отказ Тогда
			ПараметрыВыполнения.Результат = Ложь;
		Иначе
			ПараметрыВыполнения.Результат = Истина;
		КонецЕсли;
		
		ВыполнитьОбработкуОповещения(ПараметрыВыполнения.ОповещениеПриЗавершении, ПараметрыВыполнения);
		Возврат; 
	Иначе
		ТекстСообщения = НСтр("ru = 'При выполнении операции произошла ошибка.
			|Чек не напечатан на фискальном устройстве.
			|Дополнительное описание: %ДополнительноеОписание%'");
		
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДополнительноеОписание%", РезультатВыполнения.ОписаниеОшибки);
		
		Если ПараметрыВыполнения.БезВыводаСообщений Тогда 
			ПараметрыВыполнения.ТекстСообщения = ТекстСообщения;
		Иначе
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		КонецЕсли;
		
		ПараметрыВыполнения.Результат = Ложь;
		ВыполнитьОбработкуОповещения(ПараметрыВыполнения.ОповещениеПриЗавершении, ПараметрыВыполнения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
