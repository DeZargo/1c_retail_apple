﻿
#Область ПрограммныйИнтерфейс

// В функции нужно реализовать подготовку данных для дальнейшей обработки штрихкодов.
//
// Параметры:
//  Форма - УправляемаяФорма - форма документа, в которой происходит обработка,
//  ДанныеШтрихкодов - Массив - полученные штрихкоды,
//  ПараметрыЗаполнения - Структура - параметры заполнения (см. ИнтеграцияЕГАИСКлиентСервер.ПараметрыЗаполненияТабличнойЧасти()).
//
// Возвращаемое значение:
//  Структура - подготовленные данные.
//
Процедура ПодготовитьДанныеДляОбработкиШтрихкодов(Форма, ДанныеШтрихкодов, ПараметрыЗаполнения, СтруктураДействий) Экспорт
	
	ПараметрыЗаполненияНоменклатурыЕГАИС = Новый Структура;
	ПараметрыЗаполненияНоменклатурыЕГАИС.Вставить("ЗаполнитьФлагАлкогольнаяПродукция", Ложь);
	ПараметрыЗаполненияНоменклатурыЕГАИС.Вставить("ИмяКолонки", "АлкогольнаяПродукция");
	
	СтруктураДействийСДобавленнымиСтроками = Новый Структура;
	СтруктураДействийСДобавленнымиСтроками.Вставить("ЗаполнитьНоменклатуруЕГАИС", ПараметрыЗаполненияНоменклатурыЕГАИС);
	
	Если ПараметрыЗаполнения.ПересчитатьКоличествоЕдиниц Тогда
		СтруктураДействийСДобавленнымиСтроками.Вставить("ПересчитатьКоличествоЕдиниц");
	КонецЕсли;
	Если ПараметрыЗаполнения.ПересчитатьСумму Тогда
		СтруктураДействийСДобавленнымиСтроками.Вставить("ПересчитатьСумму");
	КонецЕсли;
	Если ПараметрыЗаполнения.ЗаполнитьИндексАкцизнойМарки Тогда
		СтруктураДействийСДобавленнымиСтроками.Вставить("ЗаполнитьИндексАкцизнойМарки");
	КонецЕсли;
	
	СтруктураДействийСИзмененнымиСтроками = Новый Структура;
	Если ПараметрыЗаполнения.ПересчитатьКоличествоЕдиниц Тогда
		СтруктураДействийСИзмененнымиСтроками.Вставить("ПересчитатьКоличествоЕдиниц");
	КонецЕсли;
	Если ПараметрыЗаполнения.ПересчитатьСумму Тогда
		СтруктураДействийСИзмененнымиСтроками.Вставить("ПересчитатьСумму");
	КонецЕсли;
	Если ПараметрыЗаполнения.ЗаполнитьИндексАкцизнойМарки Тогда
		СтруктураДействийСИзмененнымиСтроками.Вставить("ЗаполнитьИндексАкцизнойМарки");
	КонецЕсли;
	
	СтруктураДействий = ШтрихкодированиеНоменклатурыКлиентСервер.ПараметрыОбработкиШтрихкодов();
	
	СтруктураДействий.Штрихкоды                              = ДанныеШтрихкодов;
	СтруктураДействий.СтруктураДействийСДобавленнымиСтроками = СтруктураДействийСДобавленнымиСтроками;
	СтруктураДействий.СтруктураДействийСИзмененнымиСтроками  = СтруктураДействийСИзмененнымиСтроками;
	СтруктураДействий.ТолькоТовары                           = Истина;
	СтруктураДействий.ШтрихкодыВТЧ                           = ПараметрыЗаполнения.ШтрихкодыВТЧ;
	СтруктураДействий.МаркируемаяПродукцияВТЧ                = ПараметрыЗаполнения.МаркируемаяПродукцияВТЧ;
	
КонецПроцедуры

// В процедуре требуется реализовать алгоритм обработки полученных штрихкодов.
//
// Параметры:
//  Форма - УправляемаяФорма - форма документа, в которой происходит обработка,
//  ДанныеДляОбработки - Структура - подготовленные ранее данные для обработки,
//  КэшированныеЗначения - Структура - используется механизмом обработки изменения реквизитов ТЧ.
//
Процедура ОбработатьШтрихкоды(Форма, ДанныеДляОбработки, КэшированныеЗначения) Экспорт
	
	Если ДанныеДляОбработки.Свойство("ДанныеПоискаПоШтрихкоду") Тогда
		ОбработатьДанныеПоКодуСервер(Форма, ДанныеДляОбработки.ДанныеПоискаПоШтрихкоду);
	Иначе
		ДанныеДляОбработки.Вставить("ОбработанныеШтрихкоды", Новый Массив);
		
		Для Каждого СтруктураШтрихкода Из ДанныеДляОбработки.Штрихкоды Цикл
			СтруктураРезультат = ПодключаемоеОборудованиеРТВызовСервера.ДанныеПоискаПоШтрихкоду(СтруктураШтрихкода.Штрихкод, Новый Структура("ПараметрыСобытийПО", ДанныеДляОбработки));
			
			НайденоОбъектов = СтруктураРезультат.ЗначенияПоиска.Количество();
			Если НайденоОбъектов = 1 Тогда
				ОбработатьДанныеПоКодуСервер(Форма, СтруктураРезультат);
			ИначеЕсли НайденоОбъектов > 1 Тогда
				ПодключаемоеОборудованиеРТВызовСервера.ПодготовитьДанныеДляВыбора(СтруктураРезультат);
			КонецЕсли;
			
			ДанныеДляОбработки.ОбработанныеШтрихкоды.Добавить(СтруктураРезультат);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

// В процедуре требуется реализовать алгоритм обработки полученных штрихкодов из ТСД.
//
// Параметры:
//  Форма - УправляемаяФорма - форма документа, в которой происходит обработка,
//  ДанныеДляОбработки - Структура - подготовленные ранее данные для обработки,
//  КэшированныеЗначения - Структура - используется механизмом обработки изменения реквизитов ТЧ.
//
Процедура ОбработатьДанныеИзТСД(Форма, ДанныеДляОбработки, КэшированныеЗначения) Экспорт
	
	ДанныеПоНоменклатуре = ПодключаемоеОборудованиеРТВызовСервера.СформироватьМассивТоваров(ДанныеДляОбработки.Штрихкоды, Ложь);
	
	СтруктураДляСвертки = ДанныеПоНоменклатуре.ОпознанныеШтрихкоды;
	СтруктураДляСвертки.Вставить("УчитыватьСерийныеНомераПриСвертке", Ложь);
	
	МассивПослеСвертки = ПодключаемоеОборудованиеРТВызовСервера.СвернутьДанныеПоНоменклатуреИзТСДСервер(СтруктураДляСвертки);
	ОбновитьКоличество = ДанныеДляОбработки.ИзменятьКоличество;
	
	Для Каждого СтрокаМассива Из МассивПослеСвертки Цикл
	
		СтрокаМассива.Вставить("ЗагрузкаИзТСД", Истина);
		Если ОбновитьКоличество Тогда
			СтрокаМассива.Вставить("ОбновитьКоличество", Истина);
		КонецЕсли;
		
		Если СтрокаМассива.Свойство("СерийныйНомер") Тогда
			
			ИдентификаторСтроки = ДобавитьНайденныеСерийныеНомера(Форма, СтрокаМассива);
			
		ИначеЕсли СтрокаМассива.Свойство("Карта") Тогда
			
			ТипКарты = ?(СтрокаМассива.ЭтоРегистрационнаяКарта,  НСтр("ru = 'регистрационная'"), НСтр("ru = 'дисконтная'"));
			ТекстПредупреждения = НСтр("ru = 'По коду ""%1"" найдена %2 карта. Обработка карт в данной форме при загрузке из ТСД не предусмотрена'");
			ТекстПредупреждения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстПредупреждения, СтрокаМассива.Штрихкод, ТипКарты);
			СтрокаМассива.Вставить("ТекстПредупреждения", ТекстПредупреждения);
			
		Иначе
			
			ИдентификаторСтроки = ДобавитьНайденныеПозицииТоваров(Форма, СтрокаМассива);
			
		КонецЕсли;
		Если СтрокаМассива.Свойство("ТекстПредупреждения") Тогда
			Если ДанныеДляОбработки.Свойство("ТекстПредупреждения") Тогда
				ДанныеДляОбработки.ТекстПредупреждения.Добавить(СтрокаМассива.ТекстПредупреждения);
			Иначе
				МассивПредупреждений = Новый Массив;
				МассивПредупреждений.Добавить(СтрокаМассива.ТекстПредупреждения);
				ДанныеДляОбработки.Вставить("ТекстПредупреждения", МассивПредупреждений);
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// В процедуре требуется реализовать алгоритм заполнения массива штрихкодов по переданному отбору.
//
// Параметры:
//   МассивШтрихкодов - Массив    - результат получения штрихкодов
//   Отбор            - Структура - переданные ключи отбора:
//    * Номенклатура   - ОпределяемыйТип.Номенклатура - ссылка на номенклатуру,
//    * Характеристика - ОпределяемыйТип.ХарактеристикаНоменклатуры - ссылка на характеристику номенклатуры,
//    * Упаковка       - ОпределяемыйТип.Упаковка - ссылка на упаковку.
//
// Возвращаемое значение:
//  Массив - массив штрихкодов.
//
Процедура ПриПолученииШтрихкодовНоменклатуры(МассивШтрихкодов, Отбор) Экспорт
	
	МассивШтрихкодов = ПолучитьШтрихкодыНоменклатуры(Отбор);
	
КонецПроцедуры

// Получить данные о номенклатуре по штрихкоду. Заполняемое значение - Структура со свойствами:
//   * НоменклатураЕГАИС - СправочникСсылка.КлассификаторАлкогольнойПродукцииЕГАИС - ссылка на алкогольную продукцию,
//   * Номенклатура - ОпределяемыйТип.Номенклатура - ссылка на номенклатуру,
//   * Характеристика - ОпределяемыйТип.ХарактеристикаНоменклатуры - ссылка на характеристику номенклатуры.
//   * Упаковка - ОпределяемыйТип.Упаковка - ссылка на упаковку номенклатуры.
//   или Неопределено если не найдено
//
// Параметры:
//   ДанныеСопоставления - Структура, Неопределено - результат поиска
//   Штрихкод            - Строка                  - считанный штрихкод.
//
Процедура НайтиПоШтрихкоду(ДанныеСопоставления, Штрихкод) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Штрихкоды.Владелец КАК Номенклатура,
	|	Штрихкоды.Характеристика КАК Характеристика,
	|	Штрихкоды.Упаковка КАК Упаковка
	|ПОМЕСТИТЬ ДанныеПоШтрихкоду
	|ИЗ
	|	РегистрСведений.Штрихкоды КАК Штрихкоды
	|ГДЕ
	|	Штрихкоды.Штрихкод = &Штрихкод
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МАКСИМУМ(ЕСТЬNULL(СоответствиеНоменклатурыЕГАИС.АлкогольнаяПродукция,ЗНАЧЕНИЕ(Справочник.КлассификаторАлкогольнойПродукцииЕГАИС.ПустаяСсылка))) КАК АлкогольнаяПродукция,
	|	ТабличнаяЧасть.Номенклатура КАК Номенклатура,
	|	ТабличнаяЧасть.Характеристика КАК Характеристика
	|ПОМЕСТИТЬ СопоставленыеПозиции
	|ИЗ
	|	ДанныеПоШтрихкоду КАК ТабличнаяЧасть
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СоответствиеНоменклатурыЕГАИС КАК СоответствиеНоменклатурыЕГАИС
	|		ПО СоответствиеНоменклатурыЕГАИС.Номенклатура = ТабличнаяЧасть.Номенклатура
	|			И СоответствиеНоменклатурыЕГАИС.Характеристика = ТабличнаяЧасть.Характеристика
	|СГРУППИРОВАТЬ ПО
	|	ТабличнаяЧасть.Номенклатура,
	|	ТабличнаяЧасть.Характеристика
	|ИМЕЮЩИЕ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЕСТЬNULL(СоответствиеНоменклатурыЕГАИС.АлкогольнаяПродукция,ЗНАЧЕНИЕ(Справочник.КлассификаторАлкогольнойПродукцииЕГАИС.ПустаяСсылка))) = 1
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДанныеПоШтрихкоду.Номенклатура КАК Номенклатура,
	|	ДанныеПоШтрихкоду.Характеристика КАК Характеристика,
	|	ДанныеПоШтрихкоду.Упаковка КАК Упаковка,
	|	МАКСИМУМ(ЕСТЬNULL(СоответствиеНоменклатурыЕГАИС.АлкогольнаяПродукция, ЗНАЧЕНИЕ(Справочник.КлассификаторАлкогольнойПродукцииЕГАИС.ПустаяСсылка))) КАК АлкогольнаяПродукция
	|ИЗ
	|	ДанныеПоШтрихкоду КАК ДанныеПоШтрихкоду
	|		ЛЕВОЕ СОЕДИНЕНИЕ СопоставленыеПозиции КАК СоответствиеНоменклатурыЕГАИС
	|		ПО ДанныеПоШтрихкоду.Номенклатура = СоответствиеНоменклатурыЕГАИС.Номенклатура
	|			И ДанныеПоШтрихкоду.Характеристика = СоответствиеНоменклатурыЕГАИС.Характеристика
	|
	|СГРУППИРОВАТЬ ПО
	|	ДанныеПоШтрихкоду.Номенклатура,
	|	ДанныеПоШтрихкоду.Характеристика,
	|	ДанныеПоШтрихкоду.Упаковка";
	
	Запрос.УстановитьПараметр("Штрихкод", Штрихкод);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ДанныеСопоставления = Новый Структура;
		ДанныеСопоставления.Вставить("АлкогольнаяПродукция", Выборка.АлкогольнаяПродукция);
		ДанныеСопоставления.Вставить("Номенклатура",         Выборка.Номенклатура);
		ДанныеСопоставления.Вставить("Характеристика",       Выборка.Характеристика);
		ДанныеСопоставления.Вставить("Упаковка",             Выборка.Упаковка);
	Иначе
		ДанныеСопоставления = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

// В функции требуется определить право на регистрацию нового штрихкода для текущего пользователя.
//
// Параметры:
//   ДоступРазрешен - Булево - Истина, если есть право на регистрацию штрихкода. Ложь - в противном случае.
//
Процедура ПравоРегистрацииШтрихкодовНоменклатуры(ДоступРазрешен) Экспорт
	
	ДоступРазрешен = ПравоДоступа("Редактирование", Метаданные.РегистрыСведений.Штрихкоды);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункцииРТ

Процедура ОбработатьДанныеПоКодуСервер(Форма, СтруктураРезультат)
	
	ИдентификаторСтроки = Неопределено;
	СтрокаРезультата = СтруктураРезультат.ЗначенияПоиска[0];
	
	Если СтрокаРезультата.Свойство("Карта") Тогда
		
		ПодключаемоеОборудованиеРТВызовСервера.ВставитьПредупреждениеОНевозможностиОбработкиКарт(СтруктураРезультат, СтрокаРезультата);
		
	ИначеЕсли СтрокаРезультата.Свойство("СерийныйНомер") Тогда
		
		ПодключаемоеОборудованиеРТВызовСервера.ВставитьПредупреждениеОНевозможностиОбработкиСертификатов(СтруктураРезультат, СтрокаРезультата);
		
	Иначе
		
		ИдентификаторСтроки = ДобавитьНайденныеПозицииТоваров(Форма, СтрокаРезультата);
		
	КонецЕсли;

	Если СтрокаРезультата.Свойство("ТекстПредупреждения") Тогда
		СтруктураРезультат.Вставить("ТекстПредупреждения", СтрокаРезультата.ТекстПредупреждения);
	КонецЕсли;
	
	Если СтрокаРезультата.Свойство("НеобходимостьВводаАкцизнойМарки") Тогда
		СтруктураРезультат.Вставить("НеобходимостьВводаАкцизнойМарки", СтрокаРезультата.НеобходимостьВводаАкцизнойМарки);
	КонецЕсли;
	
	Если ИдентификаторСтроки <> Неопределено Тогда
		СтруктураРезультат.Вставить("АктивизироватьСтроку", ИдентификаторСтроки);
	КонецЕсли;
	
КонецПроцедуры

Функция ДобавитьНайденныеПозицииТоваров(Форма, СтруктураПараметров)
	
	ИдентификаторСтроки = Неопределено;
	ДанныеПродукции = ИнтеграцияЕГАИСРТ.ДанныеАлкогольнойПродукции(СтруктураПараметров.Номенклатура);
	
	ТекстСообщения = "";
	Если НЕ ИнтеграцияЕГАИСРТКлиентСервер.ПроверитьДанныеАлкогольнойПродукции(Форма, ДанныеПродукции, СтруктураПараметров.Номенклатура, ТекстСообщения) Тогда
		СтруктураПараметров.Вставить("ТекстПредупреждения", ТекстСообщения);
		Возврат ИдентификаторСтроки;
	КонецЕсли;
	
	ДобавленаСтрока = Ложь;
	ТекущаяСтрока = ПодключаемоеОборудованиеРТВызовСервера.ИнициализацияСтрокиТоваров(Форма, СтруктураПараметров, ДобавленаСтрока);
	
	Если ТекущаяСтрока.Свойство("ЕдиницаИзмерения") Тогда
		ТекущаяСтрока.ЕдиницаИзмерения = ДанныеПродукции.ЕдиницаИзмерения;
	КонецЕсли;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");
	
	Если ТекущаяСтрока.Свойство("Цена") Тогда
		ДанныеДокумента = Новый Структура;
		ДанныеДокумента.Вставить("Дата", Форма.Объект.Дата);
		
		Если Форма.Объект.Свойство("ОрганизацияЕГАИС") Тогда
			ДанныеДокумента.Вставить("Магазин", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Форма.Объект.ОрганизацияЕГАИС, "ТорговыйОбъект"));
		Иначе
			ДанныеДокумента.Вставить("Магазин", Неопределено);
		КонецЕсли;
		
		СтруктураДействий.Вставить("ЗаполнитьЦенуПродажи", ОбработкаТабличнойЧастиТоварыКлиентСервер.ПолучитьСтруктуруЗаполненияЦеныПродажиВСтрокеТЧ(ДанныеДокумента));
		СтруктураДействий.Вставить("ПересчитатьСумму");
	КонецЕсли;
	
	ИдентификаторСтроки = ПодключаемоеОборудованиеРТВызовСервера.ЗавершениеОбработкиСтрокиТоваров(Форма, ТекущаяСтрока, СтруктураДействий);
	
	Если ДобавленаСтрока Тогда
		Если ТекущаяСтрока.Свойство("МаркируемаяАлкогольнаяПродукция") Тогда
			ТекущаяСтрока.МаркируемаяАлкогольнаяПродукция = ДанныеПродукции.Маркируемый;
		КонецЕсли;
		
		ТекущаяСтрока.АлкогольнаяПродукция = ИнтеграцияЕГАИСРТВызовСервера.АлкогольнаяПродукцияПоНоменклатуре(ТекущаяСтрока.Номенклатура, ТекущаяСтрока.Характеристика);
	КонецЕсли;
	
	Если ИдентификаторСтроки <> Неопределено Тогда
		Если ТекущаяСтрока.Свойство("МаркируемаяАлкогольнаяПродукция") И ТекущаяСтрока.МаркируемаяАлкогольнаяПродукция Тогда
			СтруктураПараметров.Вставить("НеобходимостьВводаАкцизнойМарки", Истина);
		КонецЕсли;
	КонецЕсли;
	
	Возврат ИдентификаторСтроки;
	
КонецФункции

Функция ДобавитьНайденныеСерийныеНомера(Форма, СтруктураПараметров)
	
	ТекстПредупреждения = НСтр("ru = 'По коду ""%1"" найден подарочный сертификат. Обработка сертификатов в данной форме не предусмотрена'");
	ТекстПредупреждения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстПредупреждения, СтруктураПараметров.ДанныеПО);
	СтруктураПараметров.Вставить("ТекстПредупреждения", ТекстПредупреждения);
	
	Возврат Неопределено;
	
КонецФункции

// В функции требуется реализовать алгоритм получения массива штрихкодов по переданному отбору.
//
// Параметры:
//  Отбор - Структура - структура с ключами:
//   * Номенклатура - ОпределяемыйТип.Номенклатура - ссылка на номенклатуру,
//   * Характеристика - ОпределяемыйТип.ХарактеристикаНоменклатуры - ссылка на характеристику номенклатуры,
//   * Упаковка - ОпределяемыйТип.Упаковка - ссылка на упаковку.
//
// Возвращаемое значение:
//  Массив - массив штрихкодов.
//
Функция ПолучитьШтрихкодыНоменклатуры(Отбор) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Владелец", Отбор.Номенклатура);
	Запрос.УстановитьПараметр("Характеристика", Отбор.Характеристика);
	Запрос.УстановитьПараметр("Упаковка", Отбор.Упаковка);
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Штрихкоды.Штрихкод
	|ИЗ
	|	РегистрСведений.Штрихкоды КАК Штрихкоды
	|ГДЕ
	|	Штрихкоды.Владелец = &Владелец
	|	И Штрихкоды.Характеристика = &Характеристика
	|	И (Штрихкоды.Упаковка = &Упаковка
	|			ИЛИ Штрихкоды.Упаковка = ЗНАЧЕНИЕ(Справочник.УпаковкиНоменклатуры.ПустаяСсылка))";
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Штрихкод");
	
КонецФункции

#КонецОбласти