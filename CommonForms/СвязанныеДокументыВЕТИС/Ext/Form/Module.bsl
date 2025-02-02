﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЭтотОбъект.УстановитьПараметрыФункциональныхОпцийФормы(Параметры.ПараметрыФункциональныхОпций);
	
	Если ТипЗнч(Параметры.ТаблицаСвязанныхДокументов) = Тип("ТаблицаЗначений") Тогда
		ТаблицаСвязанныхДокументов = Параметры.ТаблицаСвязанныхДокументов;
	ИначеЕсли ТипЗнч(Параметры.ТаблицаСвязанныхДокументов) = Тип("ДанныеФормыКоллекция") Тогда
		ТаблицаСвязанныхДокументов = Параметры.ТаблицаСвязанныхДокументов.Выгрузить();
	Иначе
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ТолькоПросмотр = Параметры.ТолькоПросмотр;
	
	Если ТипЗнч(Параметры.ПараметрыРедактирования) = Тип("Структура") Тогда
		Если Параметры.ПараметрыРедактирования.Свойство("ТипыДокументов") Тогда
			Элементы.СвязанныеДокументыТипДокумента.РежимВыбораИзСписка = Истина;
			СписокВыбора = Элементы.СвязанныеДокументыТипДокумента.СписокВыбора;
			СписокВыбора.Очистить();
			ОбщегоНазначенияКлиентСервер.ЗаполнитьКоллекциюСвойств(Параметры.ПараметрыРедактирования.ТипыДокументов, СписокВыбора);
		КонецЕсли;
	КонецЕсли;
	
	СвязанныеДокументы.Загрузить(ТаблицаСвязанныхДокументов);
	
	ПриСозданииЧтенииНаСервере();
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийСпискаФормыСвязанныеДокументы

&НаКлиенте
Процедура СвязанныеДокументыПриИзменении(Элемент)
	Если ТекущееКоличествоСтрок <> СвязанныеДокументы.Количество() Тогда
		ОбновитьЗаголовок(ЭтотОбъект);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сохранить(Команда)
	
	Если ПроверитьЗаполнениеТаблицы() Тогда
		Закрыть(СвязанныеДокументы);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	Закрыть();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьЗаголовок(Форма)
	
	Форма.ТекущееКоличествоСтрок = Форма.СвязанныеДокументы.Количество();
	Форма.Заголовок = НСтр("ru = 'Связанные документы'") + " (" + Строка(Форма.ТекущееКоличествоСтрок) + ")";
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииЧтенииНаСервере()
	ОбновитьЗаголовок(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Функция ПроверитьЗаполнениеТаблицы()
	
	Отказ = Ложь;
	НомерСтроки = 0;
	Для Каждого СтрокаТаблицы Из СвязанныеДокументы Цикл
		НомерСтроки = НомерСтроки + 1;
		Если НЕ ЗначениеЗаполнено(СтрокаТаблицы.ТипДокумента) Тогда
			Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("СвязанныеДокументы", НомерСтроки, "ТипДокумента");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Не заполнен тип связанного документа!'"),,
				Поле,,
				Отказ)
		КонецЕсли;
	КонецЦикла;
	Возврат НЕ Отказ;
	
КонецФункции

&НаКлиенте
Процедура СвязанныеДокументыПослеУдаления(Элемент)
	ОбновитьЗаголовок(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура СвязанныеДокументыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	ОбновитьЗаголовок(ЭтотОбъект);
КонецПроцедуры

#КонецОбласти