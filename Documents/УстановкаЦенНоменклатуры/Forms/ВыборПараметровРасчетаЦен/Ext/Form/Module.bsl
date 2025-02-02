﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЗагрузкаСтарыхЦен   = Параметры.ЗагрузкаСтарыхЦен;
	ОкруглениеРучныхЦен = Параметры.ОкруглениеРучныхЦен;
	
	ЗагрузитьВидыЦен();
	
	ТолькоВыделенныеСтроки = 0;
	ТолькоНезаполненные    = 0;
	ДатаСтарыхЦен          = ТекущаяДатаСеанса();
	ПрименятьОкругление    = Истина;
	
	СпособыЗаданияЦенЗаполнятьПоДаннымИБ          = Перечисления.СпособыЗаданияЦен.ЗаполнятьПоДаннымИБ;
	СпособыЗаданияЦенРассчитыватьПоДругимВидамЦен = Перечисления.СпособыЗаданияЦен.РассчитыватьПоДругимВидамЦен;
	
	Если ОкруглениеРучныхЦен Тогда
		Элементы.ТолькоВыделенныеСтроки.Заголовок = НСтр("ru = 'Округлить строки документа'");
		
		Элементы.ОК.Заголовок = ?(ЗагрузкаСтарыхЦен, НСтр("ru = 'Загрузить'"), НСтр("ru = 'Округлить'"));
		Элементы.ВидыЦенПересчитать.Заголовок = ?(ЗагрузкаСтарыхЦен, НСтр("ru = 'Загрузить'"), НСтр("ru = 'Округлить'"));
	Иначе
		Элементы.ТолькоВыделенныеСтроки.Заголовок = НСтр("ru = 'Пересчитать строки документа'");
		
		Элементы.ОК.Заголовок = ?(ЗагрузкаСтарыхЦен, НСтр("ru = 'Загрузить'"), НСтр("ru = 'Рассчитать'"));
		Элементы.ВидыЦенПересчитать.Заголовок = ?(ЗагрузкаСтарыхЦен, НСтр("ru = 'Загрузить'"), НСтр("ru = 'Пересчитать'"));
	КонецЕсли;
	
	Элементы.ГруппаПараметрыПересчетаСтарыхЦен.Видимость = ЗагрузкаСтарыхЦен;
	Элементы.НадписьОкругление.Видимость                 = ОкруглениеРучныхЦен;
	Элементы.ВидыЦенСпособЗаданияЦены.Видимость          = Не ЗагрузкаСтарыхЦен И Не ОкруглениеРучныхЦен;
	Элементы.ТолькоНезаполненные.Видимость               = Не ОкруглениеРучныхЦен;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыВидыЦен

&НаКлиенте
Процедура ВидыЦенВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Элемент.ТекущиеДанные <> Неопределено Тогда
		ПоказатьЗначение(, Элемент.ТекущиеДанные.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВидыЦенВыбратьВсе(Команда)
	
	Для Каждого ВидЦены Из ВидыЦен Цикл
		Если Не ВидЦены.Пересчитать Тогда
			ВидЦены.Пересчитать = Истина;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидыЦенИсключитьВсе(Команда)
	
	Для Каждого ВидЦены Из ВидыЦен Цикл
		Если ВидЦены.Пересчитать Тогда
			ВидЦены.Пересчитать = Ложь;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	
	МассивВидовЦен = Новый Массив();
	
	Для Каждого ВидЦены Из ВидыЦен Цикл
		
		Если ВидЦены.Пересчитать Тогда
			МассивВидовЦен.Добавить(ВидЦены.Ссылка);
		КонецЕсли;
		
	КонецЦикла;
	
	Результат = Новый Структура();
	Результат.Вставить("ЗагрузкаСтарыхЦен",      ЗагрузкаСтарыхЦен);
	Результат.Вставить("ОкруглениеРучныхЦен",    ОкруглениеРучныхЦен);
	Результат.Вставить("ВидыЦен",                МассивВидовЦен);
	Результат.Вставить("ТолькоВыделенныеСтроки", ТолькоВыделенныеСтроки = 1);
	Результат.Вставить("ТолькоНезаполненные",    ТолькоНезаполненные = 1);
	
	Если ЗагрузкаСтарыхЦен Тогда
		
		Результат.Вставить("ДатаСтарыхЦен",        ДатаСтарыхЦен);
		Результат.Вставить("ПроцентИзмененияЦены", ПроцентИзмененияЦены);
		Результат.Вставить("ПрименятьОкругление",  ПрименятьОкругление);
		
	КонецЕсли;
	
	Закрыть(Результат);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗагрузитьВидыЦен()
	
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ВидыЦен.Ссылка            КАК Ссылка,
		|	ВидыЦен.СпособЗаданияЦены КАК СпособЗаданияЦены,
		|	ВЫБОР
		|		КОГДА
		|			ВидыЦен.СпособЗаданияЦены = ЗНАЧЕНИЕ(Перечисление.СпособыЗаданияЦен.ЗадаватьВручную)
		|		ТОГДА
		|			0
		|		КОГДА
		|			ВидыЦен.СпособЗаданияЦены = ЗНАЧЕНИЕ(Перечисление.СпособыЗаданияЦен.ЗаполнятьПоДаннымИБ)
		|		ТОГДА
		|			1
		|		КОГДА
		|			ВидыЦен.СпособЗаданияЦены = ЗНАЧЕНИЕ(Перечисление.СпособыЗаданияЦен.РассчитыватьПоДругимВидамЦен)
		|		ТОГДА
		|			2
		|	КОНЕЦ КАК ИндексКартинки
		|ИЗ
		|	Справочник.ВидыЦен КАК ВидыЦен
		|ГДЕ
		|	ВидыЦен.Ссылка В(&МассивВидовЦен)";
		
	Запрос.УстановитьПараметр("МассивВидовЦен", Параметры.ВидыЦен);
	ТаблицаВидовЦен = Запрос.Выполнить().Выгрузить();
	
	// Для того, чтобы виды цен в списке были в том же порядке, как и на форме документа,
	// загружаем их вручную.
	Для Каждого ВидЦен Из Параметры.ВидыЦен Цикл
		
		НайденныйВидЦен = ТаблицаВидовЦен.Найти(ВидЦен, "Ссылка");
		
		СтрокаВидаЦен                   = ВидыЦен.Добавить();
		СтрокаВидаЦен.Ссылка            = ВидЦен;
		СтрокаВидаЦен.СпособЗаданияЦены = НайденныйВидЦен.СпособЗаданияЦены;
		СтрокаВидаЦен.Пересчитать = Истина;
		СтрокаВидаЦен.ИндексКартинки    = НайденныйВидЦен.ИндексКартинки;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

