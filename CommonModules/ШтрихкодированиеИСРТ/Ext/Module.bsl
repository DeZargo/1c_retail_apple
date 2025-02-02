﻿#Область ПрограммныйИнтерфейс

// Выделяет из переданного массива штрихкодов упаковок элементы, в составе которых (на любом уровне вложенности, 
//   в т.ч. частично) находится продукция требуемого вида.
// 
// Параметры:
//   ШтрихкодыДляПроверки - Массив - проверяемые элементы типа СправочникСсылка.ШтрихкодыУпаковокТоваров.
//   ВидыПродукции - Массив, ПеречислениеСсылка.ВидыПродукцииИС, Неопределено - Вид отбираемой продукции.
// Возвращаемое значение:
//   Массив - Массив - подходящие элементы типа СправочникСсылка.ШтрихкодыУпаковокТоваров.
Процедура ВыделитьШтрихкодыСодержащиеВидыПродукции(ШтрихкодыУпаковок, ВидыПродукцииИС) Экспорт
	
	ШтрихкодыУпаковок = ИнтеграцияИСРТ.ШтрихкодыСодержащиеВидыПродукции(ШтрихкодыУпаковок, ВидыПродукцииИС);
	
КонецПроцедуры

// Заполняет соответствие штрихкодов данными по номенклатуре, характеристике, маркируемой продукции.
// 
// Параметры:
// 	Штрихкоды            - Соответствие - Спискок штрихкодов.
// 	КэшированныеЗначения - Структура - сохраненные значения параметров, используемых при обработке.
//
Процедура ЗаполнитьИнформациюПоШтрихкодам(Штрихкоды, КэшированныеЗначения) Экспорт
	
	Возврат;
	
КонецПроцедуры

// В процедуре нужно реализовать подготовку данных для дальнейшей обработки штрихкодов.
//
// Параметры:
//  Форма - УправляемаяФорма - форма документа, в которой происходит обработка,
//  ДанныеШтрихкодов - Массив - полученные штрихкоды,
//  ПараметрыЗаполнения - (см. ИнтеграцияЕГАИСКлиентСервер.ПараметрыЗаполненияТабличнойЧасти).
//
// Возвращаемое значение:
//  Структура - подготовленные данные.
//
Процедура ПодготовитьДанныеДляОбработкиШтрихкодов(Форма, ДанныеШтрихкодов, ПараметрыЗаполнения, СтруктураДействий) Экспорт
	
	ПараметрыСканирования = ШтрихкодированиеИСКлиентСервер.ИнициализироватьПараметрыСканирования(Форма);
	Если ШтрихкодированиеИСКлиентСервер.ДопустимаАлкогольнаяПродукция(ПараметрыСканирования) Тогда
		ШтрихкодированиеНоменклатурыЕГАИСПереопределяемый.ПодготовитьДанныеДляОбработкиШтрихкодов(
			Форма, ДанныеШтрихкодов, ПараметрыЗаполнения, СтруктураДействий)
	КонецЕсли;
	
КонецПроцедуры

// В процедуре нужно реализовать обработку штрихкодов.
// Параметры:
//   Форма - УправляемаяФорма - форма для которой будут обработаны введенные штрихкоды.
//   ДанныеДляОбработки - Структура - структура параметров обработки штрихкодов.
//									   и заполняется данными из формы.
//   КэшированныеЗначения - Структура - кэш формы.
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

// В процедуре необходимо определить вычисление вида продукции для текста запроса.
//
// Параметры:
//  ТекстЗапроса - Строка - исходящий, дополняемый текст запроса.
//
Процедура ОпределитьВидПродукцииТекстаЗапроса(ТекстЗапроса) Экспорт
	
	ОпределениеВидаПродукции =
	"	Выбор
	|		Когда Номенклатура.АлкогольнаяПродукция
	|			Тогда Значение(Перечисление.ВидыПродукцииИС.Алкогольная)
	|		Когда Номенклатура.ТабачнаяПродукция
	|			Тогда Значение(Перечисление.ВидыПродукцииИС.Табачная)
	|		Иначе Значение(Перечисление.ВидыПродукцииИС.ПустаяСсылка)
	|	Конец ";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ОпределениеВидаПродукции", ОпределениеВидаПродукции);
	
КонецПроцедуры

// В процедуре необходимо определить вычисление вида продукции для текста запроса построения дерева.
//
// Параметры:
//  ТекстЗапроса    - Строка - исходящий, дополняемый текст запроса.
//  УровнейВЗапросе - Число - количество уровней вложений.
//
Процедура ОпределитьВидПродукцииТекстаЗапросаДереваУпаковок(ТекстЗапроса, УровнейВЗапросе) Экспорт
	
	Для Уровень = 0 По УровнейВЗапросе Цикл
		
		ОпределениеВидаПродукции = 
		"ВЫБОР
		|	КОГДА ДанныеУпаковок.УпаковкаУровень"+Уровень+".Номенклатура <> НЕОПРЕДЕЛЕНО
		|		ТОГДА ВЫБОР
		|			КОГДА ДанныеУпаковок.УпаковкаУровень"+Уровень+".Номенклатура.АлкогольнаяПродукция
		|				ТОГДА Значение(Перечисление.ВидыПродукцииИС.Алкогольная)
		|			КОГДА ДанныеУпаковок.УпаковкаУровень"+Уровень+".Номенклатура.ТабачнаяПродукция
		|				ТОГДА Значение(Перечисление.ВидыПродукцииИС.Табачная)
		|			КОНЕЦ
		|	КОНЕЦ";
		
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ОпределениеВидаПродукции" + Уровень , ОпределениеВидаПродукции);
		
	КонецЦикла;
	
КонецПроцедуры

// В процедуре необходимо сформировать соответствие по коллекции ИНН. Ключ - ИНН, значение - Контрагент.
//
// Параметры:
//  КоллекцияИНН - Массив - Список ИНН.
//  Соответствие - Соответствие - Соответсвие вида:
//   * ИНН
//   * Контрагент
//
Процедура ЗаполнитьСоответствиеИННКонтрагентам(КоллекцияИНН, Соответствие) Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Контрагенты.Ссылка КАК Контрагент,
	|	Контрагенты.ИНН    КАК ИНН
	|ИЗ
	|	Справочник.Контрагенты КАК Контрагенты
	|ГДЕ
	|	Контрагенты.ИНН В (&КоллекцияИНН)");
	Запрос.УстановитьПараметр("КоллекцияИНН", КоллекцияИНН);

	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Соответствие.Вставить(Выборка.ИНН, Выборка.Контрагент);
	КонецЦикла;
	
КонецПроцедуры

// В процедуре необходимо реализовать заполнение таблицы ДанныеПоEAN на основании заполненной колонки ЗначениеШтрихкодаEAN.
// 
// Параметры:
// 	ДанныеПоШтрихкодамEAN - ТаблицаЗначений - передается с обязательной колонкой ЗначениеШтрихкодаEAN, возвращает:
// 		* Номенклатура
// 		* ПредставлениеНоменклатуры
// 		* Характеристика
// 		* ЗначениеШтрихкодаEAN
//
Процедура ЗаполнитьДанныеПоШтрихкодамEAN(ДанныеПоШтрихкодамEAN) Экспорт
	
	ШтрихкодыEAN = ДанныеПоШтрихкодамEAN.ВыгрузитьКолонку("ЗначениеШтрихкодаEAN");
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ВЫРАЗИТЬ(ШтрихкодыНоменклатуры.Владелец КАК Справочник.Номенклатура) КАК Номенклатура,
	|	ПРЕДСТАВЛЕНИЕ(ШтрихкодыНоменклатуры.Владелец) КАК ПредставлениеНоменклатуры,
	|	ШтрихкодыНоменклатуры.Характеристика КАК Характеристика,
	|	ШтрихкодыНоменклатуры.Штрихкод КАК ЗначениеШтрихкодаEAN,
	|	ВЫБОР
	|		КОГДА ВЫРАЗИТЬ(ШтрихкодыНоменклатуры.Владелец КАК Справочник.Номенклатура).АлкогольнаяПродукция
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыПродукцииИС.Алкогольная)
	|		КОГДА ВЫРАЗИТЬ(ШтрихкодыНоменклатуры.Владелец КАК Справочник.Номенклатура).ТабачнаяПродукция
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыПродукцииИС.Табачная)
	|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ВидыПродукцииИС.ПустаяСсылка)
	|	КОНЕЦ КАК ВидПродукции
	|ИЗ
	|	РегистрСведений.Штрихкоды КАК ШтрихкодыНоменклатуры
	|ГДЕ
	|	ШтрихкодыНоменклатуры.Штрихкод В(&Штрихкоды)";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	
	Запрос.УстановитьПараметр("Штрихкоды", ШтрихкодыEAN);
	
	ДанныеПоШтрихкодамEAN = Запрос.Выполнить().Выгрузить();
	
КонецПроцедуры

// В процедуре необходимо реализовать проверку необходимости выбора серии для данных по штрихкодам.
// 
// Параметры:
// 	ДанныеШтрихкода       - Структура - данные штрихкода.
// 	ПараметрыСканирования - Структура - (См. ШтрихкодированиеИСКлиентСервер.ИнициализироватьПараметрыСканирования).
// 	ТребуетсяВыбор        - Булево - исходящий, признак необходимости выбора серии.
//
Процедура ОпределитьНеобходимостьВыбораСерииДляДанныхШтрихкода(ДанныеШтрихкода, ПараметрыСканирования, ТребуетсяВыбор) Экспорт
	
	ТребуетсяВыбор = Ложь;
	
КонецПроцедуры

// В процедуре нужно реализовать заполнение массива ШтрихкодыУпаковок из данных документа.
// 
// Параметры:
// 	Документ - ДокументСсылка - проверяемый документ.
// 	ШтрихкодыУпаковок - Массив - Список штрихкодов.
//
Процедура ЗаполнитьШтрихкодыУпаковокДокумента(Документ, ШтрихкодыУпаковок) Экспорт
	
	ШтрихкодыУпаковок = Документ.ШтрихкодыУпаковок.ВыгрузитьКолонку("ЗначениеШтрихкода");
	
КонецПроцедуры

// В процедуре нужно реализовать заполнение таблицы данных данными документа основания.
// 
// Параметры:
// 	ПараметрыСканирования - (См. ШтрихкодированиеИСКлиентСервер.ИнициализироватьПараметрыСканирования).
// 	ТаблицаДанных - ТаблицаЗначений - Данные из документа основания.
Процедура СформироватьДанныеДокументаОснования(ПараметрыСканирования, ТаблицаДанных) Экспорт
	
	ИнтеграцияЕГАИСРТ.СформироватьДанныеДокументаОснования(ПараметрыСканирования.ДокументОснование, 
		ПараметрыСканирования.ДокументЕГАИС, ТаблицаДанных);
	
КонецПроцедуры

// В процедуре необходимо реализовать замену значений неопределено на пустые ссылки в строке дерева.
// 
// Параметры:
// 	СтрокаДерева - СтрокаДереваЗначений - строка дерева значений для заполнения.
//
Процедура ЗаменитьЗначенияНеопределеноНаПустыеСсылкиВСтрокеДерева(СтрокаДерева) Экспорт
	
	Если СтрокаДерева.Номенклатура = Неопределено Тогда
		СтрокаДерева.Номенклатура = Справочники.Номенклатура.ПустаяСсылка();
	КонецЕсли;
	
	Если СтрокаДерева.Характеристика = Неопределено Тогда
		СтрокаДерева.Характеристика = Справочники.ХарактеристикиНоменклатуры.ПустаяСсылка();
	КонецЕсли;
	
	Если СтрокаДерева.Серия = Неопределено Тогда
		СтрокаДерева.Серия = Справочники.СерииНоменклатуры.ПустаяСсылка();
	КонецЕсли;
	
КонецПроцедуры

// В процедуре необходимо реализовать обработку данных штрихкода для общей формы. результат обработки штрихкода следует
// вернуть в параметре РезультатОбработки.
// 
// Параметры:
// 	Форма - УправляемаяФорма - Общая форма.
// 	ДанныеШтрихкода - (См. ШтрихкодированиеИСКлиентСервер.ИнициализироватьДанныеШтрихкода).
// 	ПараметрыСканирования - (См. ШтрихкодированиеИСКлиентСервер.ИнициализироватьПараметрыСканирования).
// 	ВложенныеШтрихкоды - (См. ШтрихкодированиеИС.ИнициализироватьДанныеШтрихкода).
// 	РезультатОброботки - (См. ШтрихкодированиеИС.ИнициализироватьРезультатОбработкиШтрихкода).
Процедура ОбработатьДанныеШтрихкодаДляОбщейФормы(Форма, ДанныеШтрихкода, ПараметрыСканирования, ВложенныеШтрихкоды, РезультатОброботки) Экспорт
	
	
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

Функция СтруктураДляОбработкиСтроки() Экспорт 
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Номенклатура",          Справочники.Номенклатура.ПустаяСсылка());
	СтруктураПараметров.Вставить("Характеристика",        Справочники.ХарактеристикиНоменклатуры.ПустаяСсылка());
	СтруктураПараметров.Вставить("Упаковка",              Справочники.УпаковкиНоменклатуры.ПустаяСсылка());
	СтруктураПараметров.Вставить("Штрихкод",              "");
	СтруктураПараметров.Вставить("ШтрихкодУпаковкиЕГАИС", Справочники.ШтрихкодыУпаковокТоваров.ПустаяСсылка());
	СтруктураПараметров.Вставить("ТипУпаковки",           Перечисления.ТипыУпаковок.ПустаяСсылка());
	
	Возврат СтруктураПараметров;
	
КонецФункции

Функция СтруктураДляДобавленияСтроки() Экспорт 
	
	СтруктураСтроки = Новый Структура;
	СтруктураСтроки.Вставить("Номенклатура",   Справочники.Номенклатура.ПустаяСсылка());
	СтруктураСтроки.Вставить("Характеристика", Справочники.ХарактеристикиНоменклатуры.ПустаяСсылка());
	СтруктураСтроки.Вставить("Количество",     0);
	СтруктураСтроки.Вставить("Штрихкод",       "");
	
	Возврат СтруктураСтроки;
	
КонецФункции

#КонецОбласти

