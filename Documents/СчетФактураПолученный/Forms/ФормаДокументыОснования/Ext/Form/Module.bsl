﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого СтрокаСписка Из Параметры.СписокДокументовОснований Цикл
		СтрокаПолучательПлатежа = ДокументыОснования.Добавить();
		СтрокаПолучательПлатежа.ДокументОснование = СтрокаСписка.Значение;
	КонецЦикла;
	
	Организация = Параметры.Организация;
	Контрагент  = Параметры.Контрагент;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Модифицированность И ЗавершениеРаботы Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если Модифицированность Тогда
		
		Отказ = Истина;
		ОписаниеОповещения = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещения, НСтр("ru = 'Данные были изменены. Сохранить изменения?'"), РежимДиалогаВопрос.ДаНетОтмена, ,КодВозвратаДиалога.Да);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ПеренестиДанные();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаКлиенте
Процедура ПеренестиДанные(Отказ = Ложь, СписокДокументовОснований = Неопределено)
	
	ОчиститьСообщения();
	
	СписокДокументовОснований = Новый СписокЗначений;
	Для Индекс = 0 По ДокументыОснования.Количество() - 1 Цикл
		
		СтрокаТаблицы = ДокументыОснования[Индекс];
		
		Если НЕ ЗначениеЗаполнено(СтрокаТаблицы.ДокументОснование) Тогда
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'В строке %1 не выбран документ.'"),
				Индекс + 1);
			ОбщегоНазначенияКлиент.СообщитьПользователю(
				Текст,
				,
				"ДокументыОснования["+Индекс+"].ДокументОснование",
				,
				Отказ);
		КонецЕсли;
		
		Если СписокДокументовОснований.НайтиПоЗначению(СтрокаТаблицы.ДокументОснование) <> Неопределено
		 И ЗначениеЗаполнено(СтрокаТаблицы.ДокументОснование) Тогда
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'В строке %1 повторно указан документ %2.'"),
				Индекс + 1,
				СтрокаТаблицы.ДокументОснование);
			ОбщегоНазначенияКлиент.СообщитьПользователю(
				Текст,
				,
				"ДокументыОснования["+Индекс+"].ДокументОснование",
				,
				Отказ);
		КонецЕсли; 
		
		СписокДокументовОснований.Добавить(СтрокаТаблицы.ДокументОснование);
		
	КонецЦикла;
	
	Если НЕ Отказ Тогда
		Модифицированность = Ложь;
		ОповеститьОВыборе(СписокДокументовОснований);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		СписокДокументовОснований = Неопределено;
		ПеренестиДанные(Истина ,СписокДокументовОснований);
		Модифицированность = Ложь;
		ОповеститьОВыборе(СписокДокументовОснований);
	ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		Закрыть();
	ИначеЕсли Результат = КодВозвратаДиалога.Отмена Тогда
		// Отмена
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
