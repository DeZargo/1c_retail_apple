﻿

////////////////////////////////////////////////////////////////////////////////
// ЭлектронноеВзаимодействиеРТ: общий механизм обмена электронными документами.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

//См. ЭлектронноеВзаимодействиеПереопределяемый.ЗаполнитьРегистрационныеДанныеОрганизации.
// Процедура возвращает данные для заполнения заявки на получение уникального
// идентификатора абонента, добавления сертификата абонента.
//
// Параметры:
//  Организация - Произвольный - ссылка на элемент справочника Организации;
//  ДанныеОрганизации - Структура - данные об организации:
//    * Индекс - Строка - почтовый индекс организации.
//    * Регион - Строка - код региона организации.
//    * Район - Строка - Район.
//    * Город - Строка - Город.
//    * НаселенныйПункт - Строка - населенный пункт расположения организации.
//    * Улица - Строка - Улица.
//    * Дом - Строка - Дом.
//    * Корпус - Строка - Корпус.
//    * Квартира - Строка - Квартира.
//    * Телефон - Строка - телефон организации.
//    * Наименование - Строка - наименование организации.
//    * ИНН - Строка - ИНН организации.
//    * КПП - Строка - КПП организации.
//    * ОГРН - Строка - ОГРН организации.
//    * КодИМНС - Строка - код ИМНС организации.
//    * ЮрФизЛицо - Строка - вид лица, возможные значения: "ЮрЛицо" или "ФизЛицо".
//    * Фамилия - Строка - фамилия руководителя.
//    * Имя - Строка - имя руководителя.
//    * Отчество - Строка - отчество руководителя.
//
// Пример:
//
////// Пример для "Управление торговлей 11"
//
//	ОрганизацияОбъект = Неопределено;
//	Попытка
//		ОрганизацияОбъект = Организация.ПолучитьОбъект();
//	Исключение
//	КонецПопытки;
//
//	ДанныеОрганизации.Очистить();
//
////// Возвращаемая структура должна содержать все перечисленные ниже
////// ключи и их значения - строки
////// Проверка свойств в дальнейшем не выполняется.
//
//	ДанныеОрганизации.Вставить("ОрганизацияСсылка", Организация);
//
//// в конфигурации "Управление торговлей" не реализовано хранение
//// компонентов адреса, поэтому компоненты адреса остаются пустыми.
//
//	ДанныеОрганизации.Вставить("Индекс"         , "");
//	ДанныеОрганизации.Вставить("Регион"         , "");
//	ДанныеОрганизации.Вставить("Район"          , "");
//	ДанныеОрганизации.Вставить("Город"          , "");
//	ДанныеОрганизации.Вставить("НаселенныйПункт", "");
//	ДанныеОрганизации.Вставить("Улица"          , "");
//	ДанныеОрганизации.Вставить("Дом"            , "");
//	ДанныеОрганизации.Вставить("Корпус"         , "");
//	ДанныеОрганизации.Вставить("Квартира"       , "");
//
//	Если ОрганизацияОбъект = Неопределено Тогда
//		
//		ДанныеОрганизации.Вставить("Наименование"   , "");
//		ДанныеОрганизации.Вставить("ИНН"            , "");
//		ДанныеОрганизации.Вставить("КПП"            , "");
//		ДанныеОрганизации.Вставить("ОГРН"           , "");
//		ДанныеОрганизации.Вставить("КодИМНС"        , "");
//		ДанныеОрганизации.Вставить("ЮрФизЛицо"      , "ЮрЛицо");
//		
//		ДанныеОрганизации.Вставить("Фамилия"        , "");
//		ДанныеОрганизации.Вставить("Имя"            , "");
//		ДанныеОрганизации.Вставить("Отчество"       , "");
//	
//		Возврат;
//		
//	КонецЕсли;
//
//// получение реквизитов организации
//
//	ДанныеОрганизации.Вставить("Наименование"   , ОрганизацияОбъект.НаименованиеПолное);
//	ДанныеОрганизации.Вставить("ИНН"            , ОрганизацияОбъект.ИНН);
//	ДанныеОрганизации.Вставить("КПП"            , ОрганизацияОбъект.КПП);
//	ДанныеОрганизации.Вставить("ОГРН"           , ОрганизацияОбъект.ОГРН);
//	ДанныеОрганизации.Вставить("КодИМНС"        , "");
//
//	ВидыЛиц = Перечисления.ЮрФизЛицо;
//	Если ОрганизацияОбъект.ЮрФизЛицо = ВидыЛиц.ЮрЛицо
//		ИЛИ ОрганизацияОбъект.ЮрФизЛицо = ВидыЛиц.ЮрЛицоНеРезидент Тогда
//		ДанныеОрганизации.Вставить("ЮрФизЛицо"      , "ЮрЛицо");
//	Иначе
//		ДанныеОрганизации.Вставить("ЮрФизЛицо"      , "ФизЛицо");
//	КонецЕсли;
//
//	ДанныеОрганизации.Вставить("Фамилия" , "");
//	ДанныеОрганизации.Вставить("Имя"     , "");
//	ДанныеОрганизации.Вставить("Отчество", "");
//
//	Руководитель = ОрганизацияОбъект.ТекущийРуководитель;
//	Если НЕ Руководитель.Пустая() Тогда
//		
//		ФИОМассив = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Руководитель.Наименование, " ");
//		КоличествоЭлементов = ФИОМассив.Количество();
//		
//		Если КоличествоЭлементов > 0 Тогда
//			ДанныеОрганизации.Фамилия = ФИОМассив[0];
//		КонецЕсли;
//		
//		Если КоличествоЭлементов > 1 Тогда
//			ДанныеОрганизации.Имя = ФИОМассив[1];
//		КонецЕсли;
//		
//		Если КоличествоЭлементов > 2 Тогда
//			ДанныеОрганизации.Отчество = ФИОМассив[2];
//		КонецЕсли;
//		
//	КонецЕсли;
//
//	ДанныеОрганизации.Вставить("Телефон", "");
//
//	СтруктураПоиска = Новый Структура;
//	СтруктураПоиска.Вставить("Тип", Перечисления.ТипыКонтактнойИнформации.Телефон);
//	СтруктураПоиска.Вставить("Вид", Справочники.ВидыКонтактнойИнформации.ТелефонОрганизации);
//	СтрокиТелефона = ОрганизацияОбъект.КонтактнаяИнформация.НайтиСтроки(СтруктураПоиска);
//
//	Если СтрокиТелефона.Количество() > 0 Тогда
//		ДанныеОрганизации.Телефон = СтрокиТелефона[0].НомерТелефона;
//	КонецЕсли;
//
//
////// Пример для "Бухгалтерия предприятия, редакция 3.0":
//
//	СвойстваОрганизации = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Организация, 
//			"НаименованиеПолное, ИНН, КПП, ОГРН, КодНалоговогоОргана, ЮридическоеФизическоеЛицо");
//	
//	ОрганизацияФизЛицо = СвойстваОрганизации.ЮридическоеФизическоеЛицо = Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо;
//	
//	ДанныеОрганизации.Вставить("ОрганизацияСсылка", Организация);
//	
//	ДанныеОрганизации.Вставить("Наименование"   , СвойстваОрганизации.НаименованиеПолное);
//	ДанныеОрганизации.Вставить("ИНН"            , СвойстваОрганизации.ИНН);
//	ДанныеОрганизации.Вставить("КПП"            , СвойстваОрганизации.КПП);
//	ДанныеОрганизации.Вставить("ОГРН"           , СвойстваОрганизации.ОГРН);
//	ДанныеОрганизации.Вставить("КодИМНС"        , СвойстваОрганизации.КодНалоговогоОргана);
//	
//	Если ОрганизацияФизЛицо Тогда
//		ДанныеОрганизации.Вставить("ЮрФизЛицо"      , "ФизЛицо");
//	Иначе
//		ДанныеОрганизации.Вставить("ЮрФизЛицо"      , "ЮрЛицо");
//	КонецЕсли;
//	
//	ОтветственныеЛица = ОтветственныеЛицаБП.ОтветственныеЛица(Организация, ТекущаяДатаСеанса());
//	ДанныеОрганизации.Вставить("Фамилия" , ОтветственныеЛица.РуководительФИО.Фамилия);
//	ДанныеОрганизации.Вставить("Имя"     , ОтветственныеЛица.РуководительФИО.Имя);
//	ДанныеОрганизации.Вставить("Отчество", ОтветственныеЛица.РуководительФИО.Отчество);
//	
//
//	Если ОрганизацияФизЛицо Тогда
//		ОбъектКонтактнойИнформации = ОбщегоНазначения.ПолучитьЗначениеРеквизита(Организация, "ИндивидуальныйПредприниматель");
//		ВидКонтактнойИнформации = Справочники.ВидыКонтактнойИнформации.АдресПоПропискеФизическиеЛица;
//		ИмяСправочника = "ФизическиеЛица";
//	Иначе
//		ОбъектКонтактнойИнформации = Организация;
//		ВидКонтактнойИнформации = Справочники.ВидыКонтактнойИнформации.ЮрАдресОрганизации;
//		ИмяСправочника = "Организации";
//	КонецЕсли;
//	
//	ДанныеОрганизации.Вставить("Индекс"         , "");
//	ДанныеОрганизации.Вставить("Регион"         , "");
//	ДанныеОрганизации.Вставить("КодРегиона"     , "");
//	ДанныеОрганизации.Вставить("Район"          , "");
//	ДанныеОрганизации.Вставить("Город"          , "");
//	ДанныеОрганизации.Вставить("НаселенныйПункт", "");
//	ДанныеОрганизации.Вставить("Улица"          , "");
//	ДанныеОрганизации.Вставить("Дом"            , "");
//	ДанныеОрганизации.Вставить("Корпус"         , "");
//	ДанныеОрганизации.Вставить("Квартира"       , "");
//	
//	ТекстЗапроса =
//	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
//	|	КонтактнаяИнформация.Значение
//	|ИЗ
//	|	Справочник." + ИмяСправочника + ".КонтактнаяИнформация КАК КонтактнаяИнформация
//	|ГДЕ
//	|	КонтактнаяИнформация.Ссылка = &Ссылка
//	|	И КонтактнаяИнформация.Вид = &Вид";
//	
//	Запрос = Новый Запрос;
//	Запрос.Текст = ТекстЗапроса;
//	Запрос.УстановитьПараметр("Ссылка", ОбъектКонтактнойИнформации);
//	Запрос.УстановитьПараметр("Вид",    ВидКонтактнойИнформации);
//	Выборка = Запрос.Выполнить().Выбрать();
//	Если Выборка.Следующий() Тогда
//		
//		АдресСтруктурой = РаботаСАдресами.СведенияОбАдресе(Выборка.Значение);
//		Если АдресСтруктурой.Свойство("Индекс") Тогда
//			ДанныеОрганизации.Индекс = АдресСтруктурой.Индекс;
//		КонецЕсли;
//		Если АдресСтруктурой.Свойство("Регион") Тогда
//			ДанныеОрганизации.Регион = АдресСтруктурой.Регион;
//		КонецЕсли;
//		Если АдресСтруктурой.Свойство("КодРегиона") Тогда
//			ДанныеОрганизации.КодРегиона = АдресСтруктурой.КодРегиона;
//		КонецЕсли;
//		Если АдресСтруктурой.Свойство("Район") Тогда
//			ДанныеОрганизации.Район = АдресСтруктурой.Район;
//		КонецЕсли;
//		Если АдресСтруктурой.Свойство("Город") Тогда
//			ДанныеОрганизации.Город = АдресСтруктурой.Город;
//		КонецЕсли;
//		Если АдресСтруктурой.Свойство("НаселенныйПункт") Тогда
//			ДанныеОрганизации.НаселенныйПункт = АдресСтруктурой.НаселенныйПункт;
//		КонецЕсли;
//		Если АдресСтруктурой.Свойство("Улица") Тогда
//			ДанныеОрганизации.Улица = АдресСтруктурой.Улица;
//		КонецЕсли;
//		Если АдресСтруктурой.Свойство("Здание") И ЗначениеЗаполнено(АдресСтруктурой.Здание) Тогда
//			ДанныеОрганизации.Дом = АдресСтруктурой.Здание.Номер;
//		КонецЕсли;
//		Если АдресСтруктурой.Свойство("Корпуса") И ЗначениеЗаполнено(АдресСтруктурой.Корпуса) Тогда
//			ДанныеОрганизации.Корпус = АдресСтруктурой.Корпуса[0].Номер;
//		КонецЕсли;
//		Если АдресСтруктурой.Свойство("Помещения") И ЗначениеЗаполнено(АдресСтруктурой.Помещения) Тогда
//			ДанныеОрганизации.Квартира = АдресСтруктурой.Помещения[0].Номер;
//		КонецЕсли;
//		
//	КонецЕсли;
//	
//	ДанныеОрганизации.Вставить("Телефон", УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(
//				Организация, ?(ОрганизацияФизЛицо, Справочники.ВидыКонтактнойИнформации.ТелефонРабочийФизическиеЛица, Справочники.ВидыКонтактнойИнформации.ТелефонОрганизации)));
//
Процедура ЗаполнитьРегистрационныеДанныеОрганизации(Организация, ДанныеОрганизации) Экспорт
	
	СвойстваОрганизации = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Организация, 
			"Наименование, ИНН, КПП, ОГРН, ЮрФизЛицо");
	
	ОрганизацияФизЛицо = СвойстваОрганизации.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ИндивидуальныйПредприниматель
							ИЛИ СвойстваОрганизации.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ФизЛицо;
	
	ДанныеОрганизации.Вставить("ОрганизацияСсылка", Организация);
	
	ДанныеОрганизации.Вставить("Наименование"   , СвойстваОрганизации.Наименование);
	ДанныеОрганизации.Вставить("ИНН"            , СвойстваОрганизации.ИНН);
	ДанныеОрганизации.Вставить("КПП"            , СвойстваОрганизации.КПП);
	ДанныеОрганизации.Вставить("ОГРН"           , СвойстваОрганизации.ОГРН);
	
	Если ОрганизацияФизЛицо Тогда
		ДанныеОрганизации.Вставить("ЮрФизЛицо"      , "ФизЛицо");
	Иначе
		ДанныеОрганизации.Вставить("ЮрФизЛицо"      , "ЮрЛицо");
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработка метаданных

//См. ЭлектронноеВзаимодействиеПереопределяемый.ПолучитьСоответствиеСправочников.
// Определяет соответствие справочников библиотеки и прикладного решения.
//
// Параметры:
//  СоответствиеСправочников - Соответствие - список справочников.
//
// Пример:
//    СоответствиеСправочников.Вставить("Организации",                 "Организации");
//    СоответствиеСправочников.Вставить("Контрагенты",                 "Контрагенты");
//    СоответствиеСправочников.Вставить("ДоговорыКонтрагентов",        "ДоговорыКонтрагентов");
//    СоответствиеСправочников.Вставить("Номенклатура",                "Номенклатура");
//    СоответствиеСправочников.Вставить("ЕдиницыИзмерения",            "ЕдиницыИзмерения");
//    СоответствиеСправочников.Вставить("НоменклатураПоставщиков",     "НоменклатураПоставщиков");
//    СоответствиеСправочников.Вставить("Валюты",                      "Валюты");
//    СоответствиеСправочников.Вставить("Банки",                       "КлассификаторБанков");
//    СоответствиеСправочников.Вставить("БанковскиеСчетаОрганизаций",  "БанковскиеСчета");
//    СоответствиеСправочников.Вставить("БанковскиеСчетаКонтрагентов", "БанковскиеСчета");
//    СоответствиеСправочников.Вставить("УпаковкиНоменклатуры",        "ЕдиницыИзмерения");
//    СоответствиеСправочников.Вставить("ФизическиеЛица",              "ФизическиеЛица");
//    СоответствиеСправочников.Вставить("Партнеры",                    "Партнеры");
//    СоответствиеСправочников.Вставить("ХарактеристикиНоменклатуры",  "ХарактеристикиНоменклатуры");
//
Процедура ПолучитьСоответствиеСправочников(СоответствиеСправочников) Экспорт
	
	// Электронные документы
	СоответствиеСправочников.Вставить("Организации", "Организации");
	СоответствиеСправочников.Вставить("Контрагенты", "Контрагенты");
	//СоответствиеСправочников.Вставить("Банки",       "КлассификаторБанков");
	СоответствиеСправочников.Вставить("НоменклатураПоставщиков",     "НоменклатураПоставщиков");
	СоответствиеСправочников.Вставить("Номенклатура","Номенклатура");
	СоответствиеСправочников.Вставить("ХарактеристикиНоменклатуры","ХарактеристикиНоменклатуры");
	СоответствиеСправочников.Вставить("УпаковкиНоменклатуры","УпаковкиНоменклатуры");
	СоответствиеСправочников.Вставить("ФизическиеЛица","ФизическиеЛица");
	СоответствиеСправочников.Вставить("ЕдиницыИзмерения","БазовыеЕдиницыИзмерения");
	// Конец электронные документы
	
	
КонецПроцедуры

//См. ЭлектронноеВзаимодействиеПереопределяемый.ПолучитьСоответствиеНаименованийОбъектовМДИРеквизитов.
// В процедуре формируется соответствие для сопоставления имен переменных библиотеки,
// наименованиям объектов и реквизитов метаданных прикладного решения.
// Если в прикладном решении есть документы, на основании которых формируется ЭД,
// причем названия реквизитов данных документов отличаются от общепринятых "Организация", "Контрагент", "СуммаДокумента",
// то для этих реквизитов необходимо добавить в соответствие записи виде:
// Ключ = "ДокументВМетаданных.ОбщепринятоеНазваниеРеквизита", Значение - "ДокументВМетаданных.ДругоеНазваниеРеквизита".
// Например:
//  СоответствиеРеквизитовОбъекта.Вставить("МЗ_Покупка.Организация", "МЗ_Покупка.Учреждение");
//  СоответствиеРеквизитовОбъекта.Вставить("МЗ_Покупка.Контрагент",  "МЗ_Покупка.Грузоотправитель");
//  СоответствиеРеквизитовОбъекта.Вставить("СчетФактураВыданный.СуммаДокумента",  "СчетФактураВыданный.Основание.СуммаДокумента");
// 
// Для подсистемы ОбменСБанками требуется определение следующих полей:
//   "ПлатежноеПоручениеВМетаданных" (необязательное)
//   "БанковскийСчетОрганизации.Закрыт" (необязательное)
//   "ИНН" (обязательное)
//   "СокращенноеНаименованиеОрганизации" (необязательное)
//   "БанковскийСчетОрганизации.Организация" (обязательное для писем)
//   "БанковскийСчетОрганизации.Банк" (обязательное для писем)
//   "ПлатежноеПоручение.СчетОрганизации" (обязательное для писем)
//   "ПлатежноеПоручение.Организация" (обязательное для писем)
//
// Параметры:
//  СоответствиеРеквизитовОбъекта - Соответствие - содержит:
//    * Ключ - Строка - имя переменной, используемой в коде библиотеки;
//    * Значение - Строка - наименование объекта метаданных или реквизита объекта в прикладном решении.
//
Процедура ПолучитьСоответствиеНаименованийОбъектовМДИРеквизитов(СоответствиеРеквизитовОбъекта) Экспорт
	
	// Обмен с контрагентами начало
	СоответствиеРеквизитовОбъекта.Вставить("СчетФактураВыданныйВМетаданных",       	"СчетФактураВыданный");
	СоответствиеРеквизитовОбъекта.Вставить("СчетФактураВыданныйАвансВМетаданных",  	"СчетФактураВыданный");
	СоответствиеРеквизитовОбъекта.Вставить("СчетФактураПолученныйВМетаданных",     	"СчетФактураПолученный");
	СоответствиеРеквизитовОбъекта.Вставить("СчетФактураПолученныйАвансВМетаданных",	"СчетФактураПолученный");
	СоответствиеРеквизитовОбъекта.Вставить("РеализацияТоваровУслугВМетаданных",    	"РеализацияТоваров");
	СоответствиеРеквизитовОбъекта.Вставить("ПоступлениеТоваровУслугВМетаданных",   	"ПоступлениеТоваров");
	СоответствиеРеквизитовОбъекта.Вставить("ИННКонтрагента",                       	"ИНН");
	СоответствиеРеквизитовОбъекта.Вставить("КППКонтрагента",                       	"КПП");
	СоответствиеРеквизитовОбъекта.Вставить("НаименованиеКонтрагента",              	"Наименование");
	СоответствиеРеквизитовОбъекта.Вставить("НаименованиеКонтрагентаДляСообщенияПользователю", "Наименование");
	СоответствиеРеквизитовОбъекта.Вставить("ВнешнийКодКонтрагента",                	"ИНН");
	СоответствиеРеквизитовОбъекта.Вставить("ИННОрганизации",                       	"ИНН");
	СоответствиеРеквизитовОбъекта.Вставить("КППОрганизации",                       	"КПП");
	СоответствиеРеквизитовОбъекта.Вставить("ОГРНОрганизации",                      	"ОГРН");
	СоответствиеРеквизитовОбъекта.Вставить("НаименованиеОрганизации",              	"Наименование");
	СоответствиеРеквизитовОбъекта.Вставить("СокращенноеНаименованиеОрганизации",    "НаименованиеСокращенное");
	СоответствиеРеквизитовОбъекта.Вставить("ПолноеНаименованиеОрганизации",        	"НаименованиеПолное");
	СоответствиеРеквизитовОбъекта.Вставить("ЮридическоеФизическоеЛицо",            	"ЮрФизЛицо");
	
	СоответствиеРеквизитовОбъекта.Вставить("НомерДоговораКонтрагента",             "НомерДоговораКонтрагента");
	СоответствиеРеквизитовОбъекта.Вставить("ДатаДоговораКонтрагента",              "ДатаДоговораКонтрагента");
	
	СоответствиеРеквизитовОбъекта.Вставить("СчетФактураВыданныйАванс.СуммаДокумента", "ТипДокумента.ДокументОснование.СуммаДокумента");
	СоответствиеРеквизитовОбъекта.Вставить("СчетФактураВыданный.СуммаДокумента", "ТипДокумента.ДокументОснование.СуммаДокумента");
	// Обмен с контрагентами конец
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// Получение данных

//См. ЭлектронноеВзаимодействиеПереопределяемый.НайтиСсылкуНаОбъект.
// Находит ссылку на объект ИБ по типу, ИД и дополнительным реквизитам.
// 
// Параметры:
//  ТипОбъекта - Строка - идентификатор типа объекта, который необходимо найти;
//  ИДОбъекта - Строка - идентификатор объекта заданного типа;
//  ДополнительныеРеквизиты - Структура - набор дополнительных полей объекта для поиска;
//  Результат - Ссылка - ссылка на найденный объект.
//
Процедура НайтиСсылкуНаОбъект(ТипОбъекта, Результат, ИдОбъекта = "", ДополнительныеРеквизиты = Неопределено) Экспорт
	
	Если ДополнительныеРеквизиты = Неопределено Тогда
		ДополнительныеРеквизиты = Новый Структура;
	КонецЕсли;
	
	Результат = Неопределено;
	Если ТипОбъекта = "Контрагенты" ИЛИ ТипОбъекта = "Организации" Тогда
		
		ПараметрПоиска = "";
		ИНН = Неопределено;
		ДополнительныеРеквизиты.Свойство("ИНН", ИНН);
		Если ИНН = Неопределено Тогда
			ИНН = "";
		КонецЕсли;
		КПП = Неопределено;
		ДополнительныеРеквизиты.Свойство("КПП", КПП);
		Если КПП = Неопределено Тогда
			КПП = "";
		КонецЕсли;
		Если ЗначениеЗаполнено(ИНН + КПП) Тогда // по ИНН + КПП
			ОбменСКонтрагентамиПереопределяемый.СсылкаНаОбъектПоИННКПП(ТипОбъекта, ИНН, КПП, Результат); 
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Результат) И ДополнительныеРеквизиты.Свойство("Наименование", ПараметрПоиска) Тогда
			// по Наименованию
			ИмяМетаданных = ЭлектронноеВзаимодействиеСлужебныйПовтИсп.ИмяПрикладногоСправочника(ТипОбъекта);
			Если ТипОбъекта = "Организации" Тогда
				Результат = НайтиСсылкуНаОбъектПоРеквизиту(ИмяМетаданных, "НаименованиеСокращенное", ПараметрПоиска);
			Иначе
				Результат = НайтиСсылкуНаОбъектПоРеквизиту(ИмяМетаданных, "Наименование", ПараметрПоиска);
			КонецЕсли;
		КонецЕсли;
		
	ИначеЕсли ТипОбъекта = "НоменклатураПоставщиков" И ЗначениеЗаполнено(ДополнительныеРеквизиты) Тогда
		
		Идентификатор = "";
		Если ДополнительныеРеквизиты.Свойство("Ид") Тогда
			Идентификатор = ДополнительныеРеквизиты.Ид;
		ИначеЕсли ДополнительныеРеквизиты.Свойство("Идентификатор") Тогда
			Идентификатор = ДополнительныеРеквизиты.Идентификатор;
		Иначе
			Возврат;
		КонецЕсли;
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Идентификатор",Идентификатор);
		Если ДополнительныеРеквизиты.Свойство("Владелец") Тогда
			Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
			|	НоменклатураПоставщиков.Номенклатура КАК Номенклатура
			|ИЗ
			|	РегистрСведений.НоменклатураПоставщиков КАК НоменклатураПоставщиков
			|ГДЕ
			|	НоменклатураПоставщиков.Идентификатор = &Идентификатор
			|	И НоменклатураПоставщиков.Поставщик = &Поставщик";
				
			Запрос.УстановитьПараметр("Поставщик", ДополнительныеРеквизиты.Владелец);
		Иначе
			Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
			|	НоменклатураПоставщиков.Номенклатура КАК Номенклатура
			|ИЗ
			|	РегистрСведений.НоменклатураПоставщиков КАК НоменклатураПоставщиков
			|ГДЕ
			|	НоменклатураПоставщиков.Идентификатор = &Идентификатор
			|";
				
		КонецЕсли;
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			Результат = Выборка.Номенклатура;
		КонецЕсли;
	ИначеЕсли ТипОбъекта = "ВидыКонтактнойИнформации" Тогда
		Если ИдОбъекта = "ФаксКонтрагента" Тогда
			Результат = Неопределено;
		Иначе
			Результат = Справочники[ТипОбъекта][ИдОбъекта];
		КонецЕсли;
		
	ИначеЕсли ТипОбъекта = "ЕдиницыИзмерения" Тогда
		
		КодЕИ = Неопределено;
		Если ДополнительныеРеквизиты.Свойство("Код", КодЕИ) Тогда
			
			Запрос = Новый Запрос;
			Запрос.Текст = 
			"ВЫБРАТЬ
			|	БазовыеЕдиницыИзмерения.Ссылка КАК Ссылка
			|ИЗ
			|	Справочник.БазовыеЕдиницыИзмерения КАК БазовыеЕдиницыИзмерения
			|ГДЕ
			|	БазовыеЕдиницыИзмерения.Код = &Код";
			
			Запрос.УстановитьПараметр("Код", КодЕИ);
			
			РезультатЗапроса = Запрос.Выполнить();
			
			Выборка = Запрос.Выполнить().Выбрать();
			
			Если Выборка.Следующий() Тогда
				Результат = Выборка.Ссылка;
			КонецЕсли;
		КонецЕсли;
		
	ИначеЕсли ТипОбъекта = "СтраныМира" Тогда
		
		Результат = НайтиСсылкуНаОбъектПоРеквизиту("СтраныМира", "Код", ИдОбъекта);
		Если НЕ ЗначениеЗаполнено(Результат) Тогда
			Результат = УправлениеКонтактнойИнформацией.СтранаМираПоКодуИлиНаименованию(ИдОбъекта);
		КонецЕсли;
		
	ИначеЕсли ТипОбъекта = "ТаможенныеДекларации" Тогда
		
		Результат = НайтиСсылкуНаОбъектПоРеквизиту("НомераГТД", "Код", ИдОбъекта);
		
	КонецЕсли;
	
КонецПроцедуры

//См. ЭлектронноеВзаимодействиеПереопределяемый.ПолучитьПечатныйНомерДокумента.
// Получает печатный номер документа.
//
// Параметры:
//  СсылкаНаОбъект - ДокументСсылка - ссылка на документ информационной базы.
//  Результат - Строка - номер документа.
//
Процедура ПолучитьПечатныйНомерДокумента(СсылкаНаОбъект, Результат) Экспорт
	
	Результат = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(СсылкаНаОбъект.Номер, Истина, Истина);
	
КонецПроцедуры

//См. ЭлектронноеВзаимодействиеПереопределяемый.ПолучитьДанныеЮрФизЛица.
// Получает данные о физическом (юридическом) лице по ссылке.
//
// Параметры:
//  ЮрФизЛицо - Ссылка - ссылка на элемент справочника, по которому надо получить данные.
//  Сведения - Структура - данные юридического (физического лица).
//
Процедура ПолучитьДанныеЮрФизЛица(ЮрФизЛицо, Сведения) Экспорт
	
	Сведения = Новый Структура("Ссылка, ОфициальноеНаименование, Наименование, Представление, ПолноеНаименование,
	| ЮрФизЛицо, КодПоОКПО, ИНН, КПП, ОГРН, Фамилия, Имя, Отчество, СвидетельствоСерияНомер, СвидетельствоДатаВыдачи,
	| Банк, БИК, КоррСчет, НомерСчета, ЮридическийАдрес, ЮридическийАдресXML, ФактическийАдрес, ФактическийАдресXML,
	| Телефоны, ТелефоныXML,ЭлектроннаяПочта ");
	
	Если НЕ ЗначениеЗаполнено(ЮрФизЛицо) Тогда
		Возврат
	КонецЕсли;
	
	Сведения.Ссылка = ЮрФизЛицо;
	
	Реквизиты = "ЮрФизЛицо, НаименованиеПолное, Наименование, ИНН, КПП, КодПоОКПО";
	
	Если ТипЗнч(ЮрФизЛицо) = Тип("СправочникСсылка.Организации") Тогда
		Реквизиты = Реквизиты + ", ОГРН, СвидетельствоСерияНомер, СвидетельствоДатаВыдачи";
	КонецЕсли;
	
	СтруктураДанных = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ЮрФизЛицо, Реквизиты);
	
	СтруктураДанных.Свойство("ЮрФизЛицо",          Сведения.ЮрФизЛицо);
	СтруктураДанных.Свойство("НаименованиеПолное", Сведения.ПолноеНаименование);
	СтруктураДанных.Свойство("НаименованиеПолное", Сведения.ОфициальноеНаименование);
	СтруктураДанных.Свойство("Наименование",       Сведения.Наименование);
	СтруктураДанных.Свойство("ИНН",                Сведения.ИНН);
	СтруктураДанных.Свойство("КПП",                Сведения.КПП);
	СтруктураДанных.Свойство("КодПоОКПО",          Сведения.КодПоОКПО);
	
	СтруктураДанных.Свойство("ОГРН",                    Сведения.ОГРН);
	СтруктураДанных.Свойство("СвидетельствоСерияНомер", Сведения.СвидетельствоСерияНомер);
	СтруктураДанных.Свойство("СвидетельствоДатаВыдачи", Сведения.СвидетельствоДатаВыдачи);
	
	Если Сведения.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ИндивидуальныйПредприниматель
		ИЛИ Сведения.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ФизЛицо Тогда
		ФИО = ФизическиеЛицаКлиентСервер.ЧастиИмени(Сведения.ПолноеНаименование);
		Сведения.Вставить("Фамилия",  ФИО.Фамилия);
		Сведения.Вставить("Имя",      ФИО.Имя);
		Сведения.Вставить("Отчество", ФИО.Отчество);
	КонецЕсли;
	
	ТаблицаКИ = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(ЮрФизЛицо,,ТекущаяДатаСеанса(),Ложь);
	
	Для Каждого СтрокаТаблицыКИ Из ТаблицаКИ Цикл
		
		Если СтрокаТаблицыКИ.Вид = Справочники.ВидыКонтактнойИнформации.ЮрАдресОрганизации
			ИЛИ СтрокаТаблицыКИ.Вид = Справочники.ВидыКонтактнойИнформации.ЮрАдресКонтрагента Тогда
			
			Сведения.ЮридическийАдресXML = СтрокаТаблицыКИ.ЗначенияПолей;
			Сведения.ЮридическийАдрес = СтрокаТаблицыКИ.Представление;
			
		ИначеЕсли СтрокаТаблицыКИ.Вид = Справочники.ВидыКонтактнойИнформации.ФактАдресОрганизации
			ИЛИ СтрокаТаблицыКИ.Вид = Справочники.ВидыКонтактнойИнформации.ФактАдресКонтрагента Тогда
			
			Сведения.ФактическийАдресXML = СтрокаТаблицыКИ.ЗначенияПолей;
			Сведения.ФактическийАдрес = СтрокаТаблицыКИ.Представление;
			
		ИначеЕсли СтрокаТаблицыКИ.Вид = Справочники.ВидыКонтактнойИнформации.ТелефонОрганизации
			ИЛИ СтрокаТаблицыКИ.Вид = Справочники.ВидыКонтактнойИнформации.ТелефонКонтрагента Тогда
			
			Сведения.ТелефоныXML = СтрокаТаблицыКИ.ЗначенияПолей;
			Сведения.Телефоны = СтрокаТаблицыКИ.Представление;
			
		ИначеЕсли СтрокаТаблицыКИ.Вид = Справочники.ВидыКонтактнойИнформации.EmailОрганизации
			ИЛИ СтрокаТаблицыКИ.Вид = Справочники.ВидыКонтактнойИнформации.EmailКонтрагента Тогда
			
			Сведения.ЭлектроннаяПочта = СтрокаТаблицыКИ.Представление;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

//См. ЭлектронноеВзаимодействиеПереопределяемый.ОписаниеОрганизации.
// Возвращает текстовое описание организации по параметрам.
//
// Параметры:
//  СведенияОрганизации - Структура - сведения об организации, по которой надо составить описание.
//  Список - Строка - список запрашиваемых параметров организации.
//  СПрефиксом - Булево - признак вывода префикса параметра организации.
//  Результат - Строка - описание организации.
//
Процедура ОписаниеОрганизации(СведенияОрганизации, Результат, Список = "", СПрефиксом = Истина) Экспорт
	
	Результат = ФормированиеПечатныхФормСервер.ОписаниеОрганизации(СведенияОрганизации, Список, СПрефиксом);
	
КонецПроцедуры

//См. ЭлектронноеВзаимодействиеПереопределяемый.ЕстьПравоОткрытияЖурналаРегистрации.
// Проверяет наличие прав на открытие журнала регистрации.
//
// Параметры:
//  Результат - Булево - если пользователь имеет право на открытие журнала регистрации,
//                       в этой переменной должна быть установлена Истина.
//
Процедура ЕстьПравоОткрытияЖурналаРегистрации(Результат) Экспорт
	
	Результат = Пользователи.РолиДоступны("ПросмотрЖурналаРегистрации");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Находит ссылку на справочник по переданному реквизиту.
//
// Параметры:
//  ИмяСправочника - Строка, имя справочника, объект которого надо найти,
//  ИмяРеквизита - Строка, имя реквизита, по которому будет проведен поиск,
//  ЗначРеквизита - произвольное значение, значение реквизита, по которому будет проведен поиск,
//  Владелец - Ссылка на владельца для поиска в иерархическом справочнике.
//
Функция НайтиСсылкуНаОбъектПоРеквизиту(ИмяСправочника, ИмяРеквизита, ЗначРеквизита, Владелец = Неопределено) Экспорт
	
	Результат = Неопределено;
	
	ОбъектМетаданных = Метаданные.Справочники[ИмяСправочника];
	Если НЕ ОбщегоНазначения.ЭтоСтандартныйРеквизит(ОбъектМетаданных.СтандартныеРеквизиты, ИмяРеквизита) // нестандартный реквизит
		И НЕ ОбъектМетаданных.Реквизиты.Найти(ИмяРеквизита)<> Неопределено Тогда // другой реквизит
		Возврат Неопределено;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	ИскСправочник.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник."+ИмяСправочника+" КАК ИскСправочник
	|ГДЕ
	|	ИскСправочник."+ИмяРеквизита+" = &ЗначРеквизита";
	
	Если ЗначениеЗаполнено(Владелец) Тогда
		Запрос.Текст = Запрос.Текст + " И ИскСправочник.Владелец = &Владелец";
		Запрос.УстановитьПараметр("Владелец", 	Владелец);
	КонецЕсли;
	Запрос.УстановитьПараметр("ЗначРеквизита", ЗначРеквизита);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Результат = Выборка.Ссылка;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

