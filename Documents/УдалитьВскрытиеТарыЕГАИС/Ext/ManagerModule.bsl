﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	
	
КонецПроцедуры

// Возвращает параметры указания серий для товаров, указанных в документе.
//
// Параметры:
//	Объект - ДокументОбъект или ДанныеФормыСтруктура - документ, для которого нужно сформировать параметры проверки.
//
// Возвращаемое значение:
//	Структура - Состав полей определяется требованиями функции
//	            ОбработкаТабличнойЧастиСервер.ЗаполнитьСтатусыУказанияСерий.
//
Функция ПараметрыУказанияСерий(Объект)Экспорт
	
	ПоляСвязи = Новый Массив;
	
	ПараметрыУказанияСерий = Новый Структура;
	ИспользованиеСерийСклад = Ложь;
	
	ИспользованиеСерийСклад = ПолучитьФункциональнуюОпцию("ИспользоватьСерииНоменклатуры");
	
	ПараметрыУказанияСерий.Вставить("ИспользоватьСерииНоменклатуры", ИспользованиеСерийСклад);
	ПараметрыУказанияСерий.Вставить("ПоляСвязи",ПоляСвязи);
	ПараметрыУказанияСерий.Вставить("ЭтоНакладная", Истина);
	
	СкладскиеОперации = Новый Массив;
	СкладскиеОперации.Добавить(Перечисления.СкладскиеОперации.ПриемкаОтПоставщика);
	
	ПараметрыУказанияСерий.Вставить("СкладскиеОперации", СкладскиеОперации);
	
	Возврат ПараметрыУказанияСерий;
	
КонецФункции

// Сформировать печатные формы объектов.
//
// ВХОДЯЩИЕ:
//   ИменаМакетов    - Строка    - Имена макетов, перечисленные через запятую.
//   МассивОбъектов  - Массив    - Массив ссылок на объекты которые нужно распечатать.
//   ПараметрыПечати - Структура - Структура дополнительных параметров печати.
//
// ИСХОДЯЩИЕ:
//   КоллекцияПечатныхФорм - Таблица значений - Сформированные табличные документы.
//   ПараметрыВывода       - Структура        - Параметры сформированных табличных документов.
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
КонецПроцедуры

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область ОбновлениеИнформационнойБазы

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	УдалитьВскрытиеТарыЕГАИС.Ссылка КАК Ссылка,
	|	УдалитьВскрытиеТарыЕГАИС.Номер КАК Номер,
	|	УдалитьВскрытиеТарыЕГАИС.Дата КАК Дата,
	|	УдалитьВскрытиеТарыЕГАИС.Проведен КАК Проведен,
	|	УдалитьВскрытиеТарыЕГАИС.Магазин КАК Магазин,
	|	УдалитьВскрытиеТарыЕГАИС.Организация КАК Организация,
	|	УдалитьВскрытиеТарыЕГАИС.Ответственный КАК Ответственный,
	|	УдалитьВскрытиеТарыЕГАИС.СтатусОбработки КАК СтатусОбработки,
	|	УдалитьВскрытиеТарыЕГАИС.Комментарий КАК Комментарий,
	|	ВЫБОР
	|		КОГДА УдалитьВскрытиеТарыЕГАИС.ДокументОснование <> НЕОПРЕДЕЛЕНО
	|			ТОГДА УдалитьВскрытиеТарыЕГАИС.ДокументОснование.Номер
	|		ИНАЧЕ УдалитьВскрытиеТарыЕГАИС.Номер
	|	КОНЕЦ КАК НомерОснования,
	|	УдалитьВскрытиеТарыЕГАИС.Товары.(
	|		ИдентификаторСтроки КАК ИдентификаторСтроки,
	|		Номенклатура КАК Номенклатура,
	|		Характеристика КАК Характеристика,
	|		Количество КАК Количество,
	|		КоличествоУпаковок КАК КоличествоУпаковок,
	|		Упаковка КАК Упаковка,
	|		КлючСвязи КАК КлючСвязи,
	|		НеобходимостьВводаАкцизнойМарки КАК НеобходимостьВводаАкцизнойМарки,
	|		Справка2 КАК Справка2,
	|		Цена КАК Цена,
	|		Сумма КАК Сумма,
	|		СтавкаНДС КАК СтавкаНДС,
	|		СуммаНДС КАК СуммаНДС,
	|		Штрихкод КАК Штрихкод,
	|		УдалитьСправка1 КАК УдалитьСправка1
	|	) КАК Товары,
	|	УдалитьВскрытиеТарыЕГАИС.АкцизныеМарки.(
	|		ИдентификаторСтроки КАК ИдентификаторСтроки,
	|		КодАкцизнойМарки КАК КодАкцизнойМарки,
	|		КлючСвязи КАК КлючСвязи
	|	) КАК АкцизныеМарки
	|ИЗ
	|	Документ.УдалитьВскрытиеТарыЕГАИС КАК УдалитьВскрытиеТарыЕГАИС
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЧекЕГАИС КАК ЧекЕГАИС
	|		ПО УдалитьВскрытиеТарыЕГАИС.Номер = ЧекЕГАИС.СерийныйНомерККМ
	|			И (НАЧАЛОПЕРИОДА(УдалитьВскрытиеТарыЕГАИС.Дата, ДЕНЬ) = НАЧАЛОПЕРИОДА(ЧекЕГАИС.Дата, ДЕНЬ))
	|			И УдалитьВскрытиеТарыЕГАИС.Магазин = ЧекЕГАИС.ОрганизацияЕГАИС.ТорговыйОбъект
	|			И УдалитьВскрытиеТарыЕГАИС.Организация = ЧекЕГАИС.ОрганизацияЕГАИС.Контрагент
	|			И (ЧекЕГАИС.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийЧекаЕГАИС.ВскрытиеТары))
	|ГДЕ
	|	ЧекЕГАИС.Ссылка ЕСТЬ NULL
	|	И НЕ УдалитьВскрытиеТарыЕГАИС.ПометкаУдаления");
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		НачатьТранзакцию();
		
		Попытка
			
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить("Документ.УдалитьВскрытиеТарыЕГАИС");
			ЭлементБлокировки.УстановитьЗначение("Ссылка", Выборка.Ссылка);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			Блокировка.Заблокировать();
			
			ДанныеЗаполнения = Новый Структура;
			ДанныеЗаполнения.Вставить("Дата"            , Выборка.Дата);
			ДанныеЗаполнения.Вставить("ВидОперации"     , Перечисления.ВидыОперацийЧекаЕГАИС.ВскрытиеТары);
			ДанныеЗаполнения.Вставить("ОрганизацияЕГАИС", Справочники.КлассификаторОрганизацийЕГАИС.ОрганизацияЕГАИСПоОрганизацииИТорговомуОбъекту(Выборка.Организация, Выборка.Магазин));
			ДанныеЗаполнения.Вставить("НомерЧекаККМ"    , СтроковыеФункцииКлиентСервер.СтрокаВЧисло(ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Выборка.НомерОснования, Истина, Истина)));
			ДанныеЗаполнения.Вставить("СерийныйНомерККМ", Выборка.Номер);
			ДанныеЗаполнения.Вставить("Ответственный"   , Выборка.Ответственный);
			ДанныеЗаполнения.Вставить("Комментарий"     , Выборка.Комментарий);
			
			ЧекЕГАИС = Документы.ЧекЕГАИС.СоздатьДокумент();
			ЧекЕГАИС.Заполнить(ДанныеЗаполнения);
			
			СоответствиеСтрок = Новый Соответствие;
			
			ВыборкаТовары = Выборка.Товары.Выбрать();
			Пока ВыборкаТовары.Следующий() Цикл
				СтрокаТЧ = ЧекЕГАИС.Товары.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаТЧ, ВыборкаТовары);
				
				Если ПустаяСтрока(ВыборкаТовары.ИдентификаторСтроки) Тогда
					СтрокаТЧ.ИдентификаторСтроки = Формат(ЧекЕГАИС.Товары.Количество(), "ЧГ=0");
				КонецЕсли;
				
				СоответствиеСтрок.Вставить(ВыборкаТовары.КлючСвязи, ЧекЕГАИС.Товары.Индекс(СтрокаТЧ));
				
				Запись = РегистрыСведений.СоответствиеНоменклатурыЕГАИС.СоздатьМенеджерЗаписи();
				Запись.Номенклатура = ВыборкаТовары.Номенклатура;
				Запись.Характеристика = ВыборкаТовары.Характеристика;
				Запись.Прочитать();
				
				Если Запись.Выбран() Тогда
					СтрокаТЧ.АлкогольнаяПродукция = Запись.АлкогольнаяПродукция;
				КонецЕсли;
			КонецЦикла;
			
			ВыборкаАкцизныеМарки = Выборка.АкцизныеМарки.Выбрать();
			Пока ВыборкаАкцизныеМарки.Следующий() Цикл
				ИндексСтроки = СоответствиеСтрок[ВыборкаАкцизныеМарки.КлючСвязи];
				Если ИндексСтроки <> Неопределено Тогда
					СтрокаТовары = ЧекЕГАИС.Товары[ИндексСтроки];
					
					СтрокаАкцизныеМарки = ЧекЕГАИС.АкцизныеМарки.Добавить();
					СтрокаАкцизныеМарки.ИдентификаторСтроки = СтрокаТовары.ИдентификаторСтроки;
					СтрокаАкцизныеМарки.КодАкцизнойМарки = ВыборкаАкцизныеМарки.КодАкцизнойМарки;
				КонецЕсли;
			КонецЦикла;
			
			ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ЧекЕГАИС,,, ?(Выборка.Проведен, РежимЗаписиДокумента.Проведение, РежимЗаписиДокумента.Запись));
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			
			ТекстСообщения = НСтр("ru = 'Не удалось обработать документ %Документ%
			                            |по причине %Причина%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Документ%", Выборка.Ссылка);
			
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
			                         УровеньЖурналаРегистрации.Предупреждение,
			                         Метаданные.Документы.УдалитьВскрытиеТарыЕГАИС,
			                         Выборка.Ссылка,
			                         ТекстСообщения);
			
		КонецПопытки
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
