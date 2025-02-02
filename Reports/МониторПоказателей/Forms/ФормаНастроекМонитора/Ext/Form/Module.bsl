﻿

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	СписокПараметорв = "КратностьЧисел, 
					   |РазрезАналитики, 
					   |ТочностьРасчетаДробнойЧасти, 
					   |КоличествоКолонок,
					   |ПериодАвтообновления,
					   |Периодичность,
					   |Период";
	
	ЗаполнитьЗначенияСвойств(ЭтаФорма, Параметры, СписокПараметорв);
	
	Если Параметры.Свойство("СписокОтчетов") Тогда 
		ТаблицаОтчетов = ПолучитьИзВременногоХранилища(Параметры.СписокОтчетов);
		СписокОтчетов.Загрузить(ТаблицаОтчетов);
	КонецЕсли;

	Если Параметры.Свойство("СписокФорматовМагазина") Тогда 
		СписокФорматовМагазина.ЗагрузитьЗначения(Параметры.СписокФорматовМагазина);
	КонецЕсли;
	
	Если Параметры.Свойство("СписокМагазинов") Тогда 
		СписокМагазинов.ЗагрузитьЗначения(Параметры.СписокМагазинов);
	КонецЕсли;	
	
	ЗаполнитьРазрезыАналитики();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	НастроитьВидимостьОтборов();	
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Модифицированность Тогда
		Отказ = Истина;
		ПоказатьВопрос(Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект), 
						НСтр("ru='Настройки были изменены. Записать изменения?'"), 
						РежимДиалогаВопрос.ДаНетОтмена);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СохранитьИЗакрыть(Команда)
	
	Если Не ПроверитьЗаполнение() Тогда 
		Возврат;	
	КонецЕсли;
	
	Модифицированность = Ложь;
	СохранитьНастройки();
	Закрыть(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтметитьВсе(Команда)
	
	СнятьОтметитьРазделы(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьОтметки(Команда)
	
	СнятьОтметитьРазделы(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтандартныеНастройки(Команда)
	
	УстановитьСтандартныеНастройкиСервер();
	Модифицированность = Истина;
		
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьФорматыМагазинов(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("СписокФорматовМагазина", СписокФорматовМагазина.ВыгрузитьЗначения());
	ПараметрыФормы.Вставить("Заголовок", НСтр("ru = 'Форматы магазина'"));
	
	ОбработкаЗавершения = Новый ОписаниеОповещения("ВыбратьФорматыМагазиновЗавершение", ЭтаФорма);
	
	ОткрытьФорму("Отчет.МониторПоказателей.Форма.ФормаПодбораФорматовМагазина", 
		ПараметрыФормы, 
		ЭтаФорма, 
		ЭтаФорма,
		,
		,
		ОбработкаЗавершения,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьМагазины(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("СписокМагазинов", СписокМагазинов.ВыгрузитьЗначения());
	ПараметрыФормы.Вставить("Заголовок", НСтр("ru = 'Магазины'"));
	
	ОбработкаЗавершения = Новый ОписаниеОповещения("ВыбратьМагазиныЗавершение", ЭтаФорма);
	
	ОткрытьФорму("Отчет.МониторПоказателей.Форма.ФормаПодбораМагазинов", 
		ПараметрыФормы, 
		ЭтаФорма, 
		ЭтаФорма,
		,
		,
		ОбработкаЗавершения,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура РазрезАналитикиПриИзменении(Элемент)
	
	НастроитьВидимостьОтборов();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СписокОтчетовВидОтображенияПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.СписокОтчетов.ТекущиеДанные;
	
	Если Не ТекущиеДанные = Неопределено Тогда
		
		Если ТекущиеДанные.ВидОтображения = ПредопределенноеЗначение("Перечисление.ВидыДиаграмм.Измерительная") Или 
			ТекущиеДанные.ВидОтображения = ПредопределенноеЗначение("Перечисление.ВидыДиаграмм.Круговая") Или
			ТекущиеДанные.ВидОтображения = ПредопределенноеЗначение("Перечисление.ВидыДиаграмм.КруговаяОбъемная") Тогда 
			
			ТекущиеДанные.ЛинияТренда = Ложь;
			
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СохранитьНастройки()
	
	ХранилищеОбщихНастроек.Сохранить("МониторПоказателейМагазина", "СписокОтчетов", 				СписокОтчетов.Выгрузить());
	ХранилищеОбщихНастроек.Сохранить("МониторПоказателейМагазина", "КратностьЧисел", 				КратностьЧисел);
	ХранилищеОбщихНастроек.Сохранить("МониторПоказателейМагазина", "РазрезАналитики", 				РазрезАналитики);
	ХранилищеОбщихНастроек.Сохранить("МониторПоказателейМагазина", "ТочностьРасчетаДробнойЧасти", 	ТочностьРасчетаДробнойЧасти);
	ХранилищеОбщихНастроек.Сохранить("МониторПоказателейМагазина", "КоличествоКолонок", 			КоличествоКолонок);
	ХранилищеОбщихНастроек.Сохранить("МониторПоказателейМагазина", "ПериодАвтообновления", 			ПериодАвтообновления);
	ХранилищеОбщихНастроек.Сохранить("МониторПоказателейМагазина", "Период",						Период);
	ХранилищеОбщихНастроек.Сохранить("МониторПоказателейМагазина", "СписокФорматовМагазина",		СписокФорматовМагазина.ВыгрузитьЗначения());
	ХранилищеОбщихНастроек.Сохранить("МониторПоказателейМагазина", "СписокМагазинов",				СписокМагазинов.ВыгрузитьЗначения());
	ХранилищеОбщихНастроек.Сохранить("МониторПоказателейМагазина", "Периодичность",					Периодичность);
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьОтметитьРазделы(Флаг)
	
	Для Каждого Строка Из СписокОтчетов Цикл 
		Строка.Доступность = Флаг;	
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьВидимостьОтборов()
	
	Если РазрезАналитики = "Магазин" Тогда
		ИзменитьВидимостьКомандВыбора(Истина, Ложь);
	ИначеЕсли РазрезАналитики = "Формат магазина" Тогда 
		ИзменитьВидимостьКомандВыбора(Ложь, Истина);
	Иначе
		ИзменитьВидимостьКомандВыбора(Ложь, Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВидимостьКомандВыбора(ЗначениеВидимостьМагазин, ЗначениеВидимостьФорматМагазина)
	
	Элементы.ВыбратьМагазины.Видимость = ЗначениеВидимостьМагазин;
	Элементы.ВыбратьФорматыМагазинов.Видимость = ЗначениеВидимостьФорматМагазина;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСтандартныеНастройкиСервер()
	
	СтандартныеНастройки = МониторПоказателей.НастройкиПоУмолчанию();
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, СтандартныеНастройки);
	
	Период.Вариант = СтандартныеНастройки.Период;
	
	СписокОтчетов.Очистить();
	СписокОтчетов.Загрузить(ПолучитьИзВременногоХранилища(СтандартныеНастройки.ТаблицаРазделов));
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРазрезыАналитики()
	
	СписокРазрезов = Новый Массив;
	СписокРазрезов.Добавить("Магазин");
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьАссортимент") Тогда 
		СписокРазрезов.Добавить("Формат магазина");	
	КонецЕсли;
	
	СписокРазрезов.Добавить("Товарная группа");
	СписокРазрезов.Добавить("Иерархия номенклатуры");
	
	Элементы.РазрезАналитики.СписокВыбора.ЗагрузитьЗначения(СписокРазрезов);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьФорматыМагазиновЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
		
	Если РезультатЗакрытия = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СписокФорматовМагазина.ЗагрузитьЗначения(РезультатЗакрытия);
			
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьМагазиныЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
		
	Если РезультатЗакрытия = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СписокМагазинов.ЗагрузитьЗначения(РезультатЗакрытия);
			
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Ответ = РезультатВопроса;
	Модифицированность = Ложь;
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		СохранитьНастройки();
		Закрыть(Истина);
	ИначеЕсли Ответ = КодВозвратаДиалога.Нет Тогда
		Закрыть(Ложь);
	ИначеЕсли Ответ = КодВозвратаДиалога.Отмена Тогда 
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

