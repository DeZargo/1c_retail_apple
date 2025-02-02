﻿
&Вместо("ЗаполнитьТоварыТТНИсходящейПоВозвратуПоставщику")
Процедура КочетовЗаполнитьТоварыТТНИсходящейПоВозвратуПоставщику(ДокументОбъект, РеквизитыОснования)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДокументОснование", ДокументОбъект.ДокументОснование);
	Запрос.УстановитьПараметр("КонечныеСтатусы"  , Документы.ТТНИсходящаяЕГАИС.КонечныеСтатусы());
	Запрос.УстановитьПараметр("ЭтаСсылка"        , ДокументОбъект.Ссылка);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаДокументы.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ ОформленныеДокументы
	|ИЗ
	|	Документ.ТТНИсходящаяЕГАИС КАК ТаблицаДокументы
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтатусыДокументовЕГАИС КАК СтатусыДокументовЕГАИС
	|		ПО (СтатусыДокументовЕГАИС.Документ = ТаблицаДокументы.Ссылка)
	|ГДЕ
	|	ТаблицаДокументы.ДокументОснование = &ДокументОснование
	|	И ТаблицаДокументы.Ссылка <> &ЭтаСсылка
	|	И ТаблицаДокументы.Проведен
	|	И НЕ СтатусыДокументовЕГАИС.Статус В (&КонечныеСтатусы)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТабличнаяЧасть.Номенклатура КАК Номенклатура,
	|	ТабличнаяЧасть.Характеристика КАК Характеристика,
	|	ЕСТЬNULL(ТабличнаяЧасть.Справка2.АлкогольнаяПродукция, ЗНАЧЕНИЕ(Справочник.КлассификаторАлкогольнойПродукцииЕГАИС.ПустаяСсылка)) КАК АлкогольнаяПродукция,
	|	ТабличнаяЧасть.Справка2 КАК Справка2,
	|	ТабличнаяЧасть.Количество КАК Количество,
	|	ТабличнаяЧасть.Сумма КАК Сумма,
	|	ВЫБОР
	|		КОГДА ТабличнаяЧасть.КоличествоУпаковок = 0
	|			ТОГДА 0
	|		ИНАЧЕ ТабличнаяЧасть.СуммаНДС / ТабличнаяЧасть.КоличествоУпаковок
	|	КОНЕЦ КАК ЦенаНДС,
	|	ТабличнаяЧасть.КоличествоУпаковок КАК КоличествоУпаковок
	|ПОМЕСТИТЬ ТоварыКОформлению
	|ИЗ
	|	Документ.ВозвратТоваровПоставщику.Товары КАК ТабличнаяЧасть
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СправочникНоменклатура
	|		ПО ТабличнаяЧасть.Номенклатура = СправочникНоменклатура.Ссылка
	|ГДЕ
	|	ТабличнаяЧасть.Ссылка = &ДокументОснование
	|	И СправочникНоменклатура.АлкогольнаяПродукция
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ОформленныеТовары.Номенклатура,
	|	ОформленныеТовары.Характеристика,
	|	ОформленныеТовары.АлкогольнаяПродукция,
	|	ОформленныеТовары.Справка2,
	|	-ОформленныеТовары.Количество,
	|	-ОформленныеТовары.Сумма,
	|	0,
	|	NULL
	|ИЗ
	|	Документ.ТТНИсходящаяЕГАИС.Товары КАК ОформленныеТовары
	|ГДЕ
	|	ОформленныеТовары.Ссылка В
	|			(ВЫБРАТЬ
	|				Т.Ссылка
	|			ИЗ
	|				ОформленныеДокументы КАК Т)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТоварыКОформлению.Номенклатура КАК Номенклатура,
	|	ТоварыКОформлению.Характеристика КАК Характеристика,
	|	ТоварыКОформлению.АлкогольнаяПродукция КАК АлкогольнаяПродукция,
	|	ТоварыКОформлению.Справка2 КАК Справка2,
	|	СУММА(ТоварыКОформлению.Количество) КАК Количество,
	|	СУММА(ТоварыКОформлению.Сумма) КАК Сумма,
	|	СУММА(ТоварыКОформлению.ЦенаНДС) КАК ЦенаНДС,
	|	СУММА(ТоварыКОформлению.КоличествоУпаковок) КАК КоличествоУпаковок
	|ПОМЕСТИТЬ ТаблицаЗаполнения
	|ИЗ
	|	ТоварыКОформлению КАК ТоварыКОформлению
	|
	|СГРУППИРОВАТЬ ПО
	|	ТоварыКОформлению.Номенклатура,
	|	ТоварыКОформлению.Характеристика,
	|	ТоварыКОформлению.АлкогольнаяПродукция,
	|	ТоварыКОформлению.Справка2
	|
	|ИМЕЮЩИЕ
	|	СУММА(ТоварыКОформлению.Количество) > 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаЗаполнения.Номенклатура КАК Номенклатура,
	|	ТаблицаЗаполнения.Характеристика КАК Характеристика,
	|	ТаблицаЗаполнения.АлкогольнаяПродукция КАК АлкогольнаяПродукция,
	|	ТаблицаЗаполнения.Справка2 КАК Справка2,
	|	ТаблицаЗаполнения.Количество КАК Количество,
	|	ТаблицаЗаполнения.Сумма КАК Сумма,
	|	ЕСТЬNULL(ТаблицаЗаполнения.Номенклатура.ВидНоменклатуры.ПродаетсяВРозлив, ЛОЖЬ) КАК ПродаетсяВРозлив,
	|	ТаблицаЗаполнения.ЦенаНДС КАК ЦенаНДС,
	|	ТаблицаЗаполнения.КоличествоУпаковок КАК КоличествоУпаковок
	|ИЗ
	|	ТаблицаЗаполнения КАК ТаблицаЗаполнения
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СоответствиеНоменклатурыЕГАИС.АлкогольнаяПродукция КАК АлкогольнаяПродукция,
	|	СоответствиеНоменклатурыЕГАИС.Номенклатура КАК Номенклатура,
	|	СоответствиеНоменклатурыЕГАИС.Характеристика КАК Характеристика
	|ИЗ
	|	ТаблицаЗаполнения КАК ТаблицаЗаполнения
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СоответствиеНоменклатурыЕГАИС КАК СоответствиеНоменклатурыЕГАИС
	|		ПО ТаблицаЗаполнения.Номенклатура = СоответствиеНоменклатурыЕГАИС.Номенклатура
	|			И ТаблицаЗаполнения.Характеристика = СоответствиеНоменклатурыЕГАИС.Характеристика";
	
	Результат = Запрос.ВыполнитьПакет();
	
	ТаблицаДокумента    = Результат[Результат.Количество() - 2].Выгрузить();
	ТаблицаСоответствий = Результат[Результат.Количество() - 1].Выгрузить();
	
	ДокументОбъект.Товары.Очистить();
	
	Для Каждого СтрокаДокумента Из ТаблицаДокумента Цикл
		
		СтрокаТЧ = ДокументОбъект.Товары.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТЧ, СтрокаДокумента);
		
		Если НЕ ЗначениеЗаполнено(СтрокаТЧ.АлкогольнаяПродукция) Тогда
			СтруктураПоиска = Новый Структура("Номенклатура, Характеристика");
			ЗаполнитьЗначенияСвойств(СтруктураПоиска, СтрокаДокумента);
			
			МассивСтрокПоАлкогольнойПродукции = ТаблицаСоответствий.НайтиСтроки(СтруктураПоиска);
			
			Если МассивСтрокПоАлкогольнойПродукции.Количество() > 0  Тогда
				
				СтрокаТЧ.АлкогольнаяПродукция = МассивСтрокПоАлкогольнойПродукции[0].АлкогольнаяПродукция;
				
			КонецЕсли;
		КонецЕсли;
		
		Если РеквизитыОснования.ЦенаВключаетНДС Тогда
			Если СтрокаДокумента.КоличествоУпаковок = 0 Тогда
				СтрокаТЧ.Цена = СтрокаДокумента.Сумма;
			Иначе
				СтрокаТЧ.Цена = Окр(СтрокаДокумента.Сумма / СтрокаДокумента.КоличествоУпаковок, 4);
			КонецЕсли;
		Иначе
			Если СтрокаДокумента.КоличествоУпаковок = 0 Тогда
				СтрокаТЧ.Цена = СтрокаДокумента.Сумма + СтрокаДокумента.ЦенаНДС;
			Иначе
				СтрокаТЧ.Цена = Окр(СтрокаДокумента.Сумма / СтрокаДокумента.КоличествоУпаковок, 4) + СтрокаДокумента.ЦенаНДС;
			КонецЕсли;
		КонецЕсли;
		
		Если СтрокаДокумента.ПродаетсяВРозлив Тогда
			ДокументОбъект.Упакована = Ложь;
		КонецЕсли;
		
	КонецЦикла;
	
	//Если ДокументОбъект.Товары.Количество() = 0 Тогда
	//	ТекстОшибки = НСтр("ru = 'Нет данных для заполнения документа'");
	//	ВызватьИсключение ТекстОшибки;
	//КонецЕсли;

КонецПроцедуры
