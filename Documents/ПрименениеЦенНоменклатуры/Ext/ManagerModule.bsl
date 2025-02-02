﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Получает текст запроса заполнения цен.
//
// Параметры:
//  ПоДокументуОснованию - Булево, 
//
// Возвращаемое значение:
//  Строка
//
Функция ТекстЗапросаЗаполненияЦен(ПоДокументуОснованию, ОбъектЦенообразования) Экспорт
	
	Если ТипЗнч(ОбъектЦенообразования) = Тип("СправочникСсылка.Склады") Тогда
		Магазин = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ОбъектЦенообразования, "Магазин");
	Иначе
		Магазин = ОбъектЦенообразования;
	КонецЕсли;

	Если ПоДокументуОснованию Тогда
		ТекстЗапроса = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ПодЗапрос.Номенклатура КАК Номенклатура,
		|	ПодЗапрос.Характеристика КАК Характеристика,
		|	ПодЗапрос.Упаковка КАК Упаковка,
		|	ПодЗапрос.ВидЦен КАК ВидЦен,
		|	ПодЗапрос.Цена КАК Цена,
		|	ПодЗапрос.Номенклатура.ЦеноваяГруппа КАК ЦеноваяГруппа,
		|	ДокументыУстановкиЦен.Дата КАК Дата
		|ПОМЕСТИТЬ ТаблицаТовары
		|ИЗ
		|	(ВЫБРАТЬ
		|		Товары.Номенклатура КАК Номенклатура,
		|		Товары.Характеристика КАК Характеристика,
		|		Товары.Упаковка КАК Упаковка,
		|		Товары.ВидЦены КАК ВидЦен,
		|		Товары.Цена КАК Цена,
		|		Товары.Номенклатура.ЦеноваяГруппа КАК ЦеноваяГруппа,
		|		Товары.Ссылка КАК УстановкаЦен
		|	ИЗ
		|		Документ.УстановкаЦенНоменклатуры.Товары КАК Товары
		|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СправочникНоменклатура
		|				ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыНоменклатуры КАК ВидыНоменклатуры
		|				ПО СправочникНоменклатура.ВидНоменклатуры = ВидыНоменклатуры.Ссылка
		|			ПО Товары.Номенклатура = СправочникНоменклатура.Ссылка
		|	ГДЕ
		|		Товары.Ссылка = &ОграниченияЗапроса
		|		И (ВидыНоменклатуры.ИспользованиеХарактеристик = ЗНАЧЕНИЕ(Перечисление.ВариантыВеденияДополнительныхДанныхПоНоменклатуре.НеИспользовать)
		|				ИЛИ ВидыНоменклатуры.ИспользованиеХарактеристик <> ЗНАЧЕНИЕ(Перечисление.ВариантыВеденияДополнительныхДанныхПоНоменклатуре.НеИспользовать)
		|					И Товары.Характеристика <> ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка))) КАК ПодЗапрос
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.УстановкаЦенНоменклатуры КАК ДокументыУстановкиЦен
		|		ПО ПодЗапрос.УстановкаЦен = ДокументыУстановкиЦен.Ссылка
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Номенклатура,
		|	ВидЦен
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ЦеновыеГруппы.ЦеноваяГруппа КАК ЦеноваяГруппа,
		|	ЦеновыеГруппы.ВидЦен КАК ВидЦен
		|ПОМЕСТИТЬ ЦеновыеГруппыПравила
		|ИЗ
		|	Справочник.ПравилаЦенообразования.ЦеновыеГруппы КАК ЦеновыеГруппы
		|ГДЕ
		|	ЦеновыеГруппы.Ссылка = &ПравилоЦенообразования
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	ВидЦен,
		|	ЦеноваяГруппа
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ВидЦеныПравила.ВидЦен КАК ВидЦен
		|ПОМЕСТИТЬ ВидЦеныПравила
		|ИЗ
		|	Справочник.ПравилаЦенообразования КАК ВидЦеныПравила
		|ГДЕ
		|	ВидЦеныПравила.Ссылка = &ПравилоЦенообразования
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ВложенныйЗапрос.Номенклатура КАК Номенклатура,
		|	ВложенныйЗапрос.Характеристика КАК Характеристика,
		|	ВложенныйЗапрос.Упаковка КАК Упаковка,
		|	ВложенныйЗапрос.Цена КАК Цена,
		|	ЕСТЬNULL(ДействующиеЦеныНоменклатуры.Цена, 0) КАК ТекущаяДействующаяЦена,
		|	ВЫБОР
		|		КОГДА ЕСТЬNULL(ДействующиеЦеныНоменклатуры.Цена, 0) > 0
		|			ТОГДА (ВложенныйЗапрос.Цена / ДействующиеЦеныНоменклатуры.Цена - 1) * 100
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК ОтношениеЦенВПроцентах
		|ИЗ
		|	(ВЫБРАТЬ
		|		ПодЗапрос.Номенклатура КАК Номенклатура,
		|		ПодЗапрос.Характеристика КАК Характеристика,
		|		ВЫБОР
		|			КОГДА МАКСИМУМ(ПодЗапрос.ЦенаПоЦеновымГруппам) > 0
		|				ТОГДА МАКСИМУМ(ПодЗапрос.УпаковкаПоЦеновымГруппам)
		|			ИНАЧЕ МАКСИМУМ(ПодЗапрос.УпаковкаПоВидуЦен)
		|		КОНЕЦ КАК Упаковка,
		|		ПодЗапрос.ДатаУстановки КАК ДатаУстановки,
		|		ВЫБОР
		|			КОГДА МАКСИМУМ(ПодЗапрос.ЦенаПоЦеновымГруппам) > 0
		|				ТОГДА МАКСИМУМ(ПодЗапрос.ЦенаПоЦеновымГруппам)
		|			ИНАЧЕ МАКСИМУМ(ПодЗапрос.ЦенаПоВидуЦен)
		|		КОНЕЦ КАК Цена,
		|		ВЫБОР
		|			КОГДА МАКСИМУМ(ПодЗапрос.ЦенаПоЦеновымГруппам) > 0
		|				ТОГДА МАКСИМУМ(ПодЗапрос.ВидЦенПоЦеновымГруппам)
		|			ИНАЧЕ МАКСИМУМ(ПодЗапрос.ВидЦенПоВидуЦен)
		|		КОНЕЦ КАК ВидЦены
		|	ИЗ
		|		(ВЫБРАТЬ
		|			ТаблицаТовары.Номенклатура КАК Номенклатура,
		|			ТаблицаТовары.Характеристика КАК Характеристика,
		|			ТаблицаТовары.Упаковка КАК УпаковкаПоВидуЦен,
		|			ЗНАЧЕНИЕ(Справочник.УпаковкиНоменклатуры.ПустаяСсылка) КАК УпаковкаПоЦеновымГруппам,
		|			ТаблицаТовары.Дата КАК ДатаУстановки,
		|			ТаблицаТовары.Цена КАК ЦенаПоВидуЦен,
		|			0 КАК ЦенаПоЦеновымГруппам,
		|			ВидЦеныПравила.ВидЦен КАК ВидЦенПоВидуЦен,
		|			ЗНАЧЕНИЕ(Справочник.ВидыЦен.ПустаяСсылка) КАК ВидЦенПоЦеновымГруппам
		|		ИЗ
		|			ВидЦеныПравила КАК ВидЦеныПравила
		|				ЛЕВОЕ СОЕДИНЕНИЕ ТаблицаТовары КАК ТаблицаТовары
		|				ПО ВидЦеныПравила.ВидЦен = ТаблицаТовары.ВидЦен
		|		
		|		ОБЪЕДИНИТЬ ВСЕ
		|		
		|		ВЫБРАТЬ
		|			ТаблицаТовары.Номенклатура,
		|			ТаблицаТовары.Характеристика,
		|			ЗНАЧЕНИЕ(Справочник.УпаковкиНоменклатуры.ПустаяСсылка),
		|			ТаблицаТовары.Упаковка,
		|			ТаблицаТовары.Дата,
		|			0,
		|			ТаблицаТовары.Цена,
		|			ЗНАЧЕНИЕ(Справочник.ВидыЦен.ПустаяСсылка),
		|			ЦеновыеГруппыПравила.ВидЦен
		|		ИЗ
		|			ЦеновыеГруппыПравила КАК ЦеновыеГруппыПравила
		|				ЛЕВОЕ СОЕДИНЕНИЕ ТаблицаТовары КАК ТаблицаТовары
		|				ПО ЦеновыеГруппыПравила.ВидЦен = ТаблицаТовары.ВидЦен
		|					И ЦеновыеГруппыПравила.ЦеноваяГруппа = ТаблицаТовары.ЦеноваяГруппа) КАК ПодЗапрос
		|	
		|	СГРУППИРОВАТЬ ПО
		|		ПодЗапрос.Номенклатура,
		|		ПодЗапрос.Характеристика,
		|		ПодЗапрос.ДатаУстановки) КАК ВложенныйЗапрос
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДействующиеЦеныНоменклатуры.СрезПоследних(
		|				&Дата,
		|				ОбъектЦенообразования = &ОбъектЦенообразования
		|					И Регистратор <> &Ссылка) КАК ДействующиеЦеныНоменклатуры
		|		ПО ВложенныйЗапрос.Номенклатура = ДействующиеЦеныНоменклатуры.Номенклатура
		|			И ВложенныйЗапрос.Характеристика = ДействующиеЦеныНоменклатуры.Характеристика
		|			И ВложенныйЗапрос.Упаковка = ДействующиеЦеныНоменклатуры.Упаковка
		|ГДЕ
		|	ВложенныйЗапрос.Цена <> ЕСТЬNULL(ДействующиеЦеныНоменклатуры.Цена, 0)";
		
	Иначе // не по документу основанию
			
		ИспользоватьАссортимент = ПолучитьФункциональнуюОпцию("УстанавливатьВидыЦенВАссортименте")
									И АссортиментСервер.ПолучитьФункциональнуюОпциюКонтроляАссортимента(Магазин);
									
		Если ИспользоватьАссортимент Тогда // Запросы дополняются данными по ассортименту.
		
			ТекстЗапроса = "
			|ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	Ассортимент.Номенклатура КАК Номенклатура,
			|	Ассортимент.ВидЦен КАК ВидЦен
			|ПОМЕСТИТЬ втАссортиментСВидомЦен
			|ИЗ
			|	РегистрСведений.Ассортимент.СрезПоследних(КОНЕЦПЕРИОДА(&Дата, ДЕНЬ), ОбъектПланирования = &ФорматОбъектаЦенообразования) КАК Ассортимент
			|	ГДЕ (Ассортимент.РазрешеныЗакупки
			|		ИЛИ Ассортимент.РазрешеныПродажи)
			|ИНДЕКСИРОВАТЬ ПО
			|	Номенклатура,
			|	ВидЦен
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	ВложенныйЗапрос.Номенклатура КАК Номенклатура,
			|	ВложенныйЗапрос.Характеристика КАК Характеристика,
			|	ВложенныйЗапрос.Упаковка КАК Упаковка,
			|	ВложенныйЗапрос.Цена КАК Цена,
			|	ЕСТЬNULL(ДействующиеЦеныНоменклатуры.Цена, 0) КАК ТекущаяДействующаяЦена,
			|	ВЫБОР
			|		КОГДА ЕСТЬNULL(ДействующиеЦеныНоменклатуры.Цена, 0) > 0
			|			ТОГДА (ВложенныйЗапрос.Цена / ДействующиеЦеныНоменклатуры.Цена - 1) * 100
			|		ИНАЧЕ 0
			|	КОНЕЦ КАК ОтношениеЦенВПроцентах
			|ИЗ
			|	(ВЫБРАТЬ
			|		АссортиментСВидомЦен.Номенклатура КАК Номенклатура,
			|		ЦеныНоменклатурыПоАссортименту.Характеристика КАК Характеристика,
			|		ЦеныНоменклатурыПоАссортименту.Упаковка КАК Упаковка,
			|		ЕСТЬNULL(ЦеныНоменклатурыПоАссортименту.Цена, 0) КАК Цена
			|	ИЗ
			|		втАссортиментСВидомЦен КАК АссортиментСВидомЦен
			|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры.СрезПоследних(
			|					&Дата,
			|					ВидЦены В
			|							(ВЫБРАТЬ РАЗЛИЧНЫЕ
			|								Ц.ВидЦен
			|							ИЗ
			|								втАссортиментСВидомЦен КАК Ц)
			|						И Номенклатура В
			|							(ВЫБРАТЬ РАЗЛИЧНЫЕ
			|								Т.Номенклатура
			|							ИЗ
			|								втАссортиментСВидомЦен КАК Т)) КАК ЦеныНоменклатурыПоАссортименту
			|			ПО (ЦеныНоменклатурыПоАссортименту.Номенклатура = АссортиментСВидомЦен.Номенклатура)
			|				И (ЦеныНоменклатурыПоАссортименту.ВидЦены = АссортиментСВидомЦен.ВидЦен)) КАК ВложенныйЗапрос
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДействующиеЦеныНоменклатуры.СрезПоследних(
			|				&Дата,
			|				ОбъектЦенообразования = &ОбъектЦенообразования
			|					И Регистратор <> &Ссылка) КАК ДействующиеЦеныНоменклатуры
			|		ПО ВложенныйЗапрос.Номенклатура = ДействующиеЦеныНоменклатуры.Номенклатура
			|			И ВложенныйЗапрос.Характеристика = ДействующиеЦеныНоменклатуры.Характеристика
			|			И ВложенныйЗапрос.Упаковка = ДействующиеЦеныНоменклатуры.Упаковка
			|ГДЕ
			|	ВложенныйЗапрос.Цена <> ЕСТЬNULL(ДействующиеЦеныНоменклатуры.Цена, 0)";   
			
		Иначе // Не используется ассортимент магазинов.
			
			ТекстЗапроса = "ВЫБРАТЬ
			|	ЦеновыеГруппы.ЦеноваяГруппа КАК ЦеноваяГруппа,
			|	ЦеновыеГруппы.ВидЦен КАК ВидЦен
			|ПОМЕСТИТЬ ЦеновыеГруппыПравила
			|ИЗ
			|	Справочник.ПравилаЦенообразования.ЦеновыеГруппы КАК ЦеновыеГруппы
			|ГДЕ
			|	ЦеновыеГруппы.Ссылка = &ПравилоЦенообразования
			|
			|ИНДЕКСИРОВАТЬ ПО
			|	ВидЦен,
			|	ЦеноваяГруппа
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	ВидЦеныПравила.ВидЦен КАК ВидЦен
			|ПОМЕСТИТЬ ВидЦеныПравила
			|ИЗ
			|	Справочник.ПравилаЦенообразования КАК ВидЦеныПравила
			|ГДЕ
			|	ВидЦеныПравила.Ссылка = &ПравилоЦенообразования
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	ВложенныйЗапрос.Номенклатура КАК Номенклатура,
			|	ВложенныйЗапрос.Характеристика КАК Характеристика,
			|	ВложенныйЗапрос.Упаковка КАК Упаковка,
			|	ВложенныйЗапрос.Цена КАК Цена,
			|	ЕСТЬNULL(ДействующиеЦеныНоменклатуры.Цена, 0) КАК ТекущаяДействующаяЦена,
			|	ВЫБОР
			|		КОГДА ЕСТЬNULL(ДействующиеЦеныНоменклатуры.Цена, 0) > 0
			|			ТОГДА (ВложенныйЗапрос.Цена / ДействующиеЦеныНоменклатуры.Цена - 1) * 100
			|		ИНАЧЕ 0
			|	КОНЕЦ КАК ОтношениеЦенВПроцентах
			|ИЗ
			|	(ВЫБРАТЬ
			|		ПодЗапрос.Номенклатура КАК Номенклатура,
			|		ПодЗапрос.Характеристика КАК Характеристика,
			|		ВЫБОР
			|			КОГДА МАКСИМУМ(ПодЗапрос.ЦенаПоЦеновымГруппам) > 0
			|				ТОГДА МАКСИМУМ(ПодЗапрос.УпаковкаПоЦеновымГруппам)
			|			ИНАЧЕ МАКСИМУМ(ПодЗапрос.УпаковкаПоВидуЦен)
			|		КОНЕЦ КАК Упаковка,
			|		ВЫБОР
			|			КОГДА МАКСИМУМ(ПодЗапрос.ЦенаПоЦеновымГруппам) > 0
			|				ТОГДА МАКСИМУМ(ПодЗапрос.ЦенаПоЦеновымГруппам)
			|			ИНАЧЕ МАКСИМУМ(ПодЗапрос.ЦенаПоВидуЦен)
			|		КОНЕЦ КАК Цена
			|	ИЗ
			|		(ВЫБРАТЬ
			|			ЦеныНоменклатурыПоВидуЦен.Номенклатура КАК Номенклатура,
			|			ЦеныНоменклатурыПоВидуЦен.Характеристика КАК Характеристика,
			|			ЦеныНоменклатурыПоВидуЦен.Упаковка КАК УпаковкаПоВидуЦен,
			|			ЗНАЧЕНИЕ(Справочник.УпаковкиНоменклатуры.ПустаяСсылка) КАК УпаковкаПоЦеновымГруппам,
			|			ЦеныНоменклатурыПоВидуЦен.Цена КАК ЦенаПоВидуЦен,
			|			0 КАК ЦенаПоЦеновымГруппам
			|		ИЗ
			|			РегистрСведений.ЦеныНоменклатуры.СрезПоследних(
			|					&Дата,
			|					ВидЦены В
			|						(ВЫБРАТЬ
			|							ВидЦеныПравила.ВидЦен
			|						ИЗ
			|							ВидЦеныПравила КАК ВидЦеныПравила)) КАК ЦеныНоменклатурыПоВидуЦен
			|		
			|		ОБЪЕДИНИТЬ ВСЕ
			|		
			|		ВЫБРАТЬ
			|			СправочникНоменклатура.Ссылка,
			|			ЦеныНоменклатурыПоЦеновымГруппам.Характеристика,
			|			ЗНАЧЕНИЕ(Справочник.УпаковкиНоменклатуры.ПустаяСсылка),
			|			ЦеныНоменклатурыПоЦеновымГруппам.Упаковка,
			|			0,
			|			ЕСТЬNULL(ЦеныНоменклатурыПоЦеновымГруппам.Цена, 0)
			|		ИЗ
			|			ЦеновыеГруппыПравила КАК ЦеновыеГруппыПравила
			|				ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СправочникНоменклатура
			|				ПО ЦеновыеГруппыПравила.ЦеноваяГруппа = СправочникНоменклатура.ЦеноваяГруппа
			|				ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры.СрезПоследних(
			|						&Дата,
			|						ВидЦены В
			|							(ВЫБРАТЬ РАЗЛИЧНЫЕ
			|								ЦеновыеГруппыПравила.ВидЦен
			|							ИЗ
			|								ЦеновыеГруппыПравила КАК ЦеновыеГруппыПравила)) КАК ЦеныНоменклатурыПоЦеновымГруппам
			|				ПО (ЦеныНоменклатурыПоЦеновымГруппам.Номенклатура = СправочникНоменклатура.Ссылка)
			|					И (ЦеныНоменклатурыПоЦеновымГруппам.ВидЦены = ЦеновыеГруппыПравила.ВидЦен)) КАК ПодЗапрос
			|	
			|	СГРУППИРОВАТЬ ПО
			|		ПодЗапрос.Номенклатура,
			|		ПодЗапрос.Характеристика) КАК ВложенныйЗапрос
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДействующиеЦеныНоменклатуры.СрезПоследних(
			|				&Дата,
			|				ОбъектЦенообразования = &ОбъектЦенообразования
			|					И Регистратор <> &Ссылка) КАК ДействующиеЦеныНоменклатуры
			|		ПО ВложенныйЗапрос.Номенклатура = ДействующиеЦеныНоменклатуры.Номенклатура
			|			И ВложенныйЗапрос.Характеристика = ДействующиеЦеныНоменклатуры.Характеристика
			|			И ВложенныйЗапрос.Упаковка = ДействующиеЦеныНоменклатуры.Упаковка
			|ГДЕ
			|	ВложенныйЗапрос.Цена <> ЕСТЬNULL(ДействующиеЦеныНоменклатуры.Цена, 0)";   
					
		КонецЕсли;
	КонецЕсли;
	
	Возврат ТекстЗапроса;
	
КонецФункции

// Инициализирует таблицы значений, содержащие данные табличных частей документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства) Экспорт

	Запрос = Новый Запрос("ВЫБРАТЬ
	|	ТаблицаТовары.Номенклатура                 КАК Номенклатура,
	|	ТаблицаТовары.Характеристика               КАК Характеристика,
	|	ТаблицаТовары.Упаковка                     КАК Упаковка,
	|	ТаблицаТовары.Цена                         КАК Цена,
	|	ТаблицаТовары.Ссылка.Дата                  КАК Период,
	|	ТаблицаТовары.Ссылка.ОбъектЦенообразования КАК ОбъектЦенообразования
	|ИЗ
	|	Документ.ПрименениеЦенНоменклатуры.Товары КАК ТаблицаТовары
	|ГДЕ
	|	ТаблицаТовары.Ссылка = &Ссылка
	|	И (ТаблицаТовары.Номенклатура.ВидНоменклатуры.ИспользованиеХарактеристик = ЗНАЧЕНИЕ(Перечисление.ВариантыВеденияДополнительныхДанныхПоНоменклатуре.НеИспользовать)
	|			ИЛИ ТаблицаТовары.Номенклатура.ВидНоменклатуры.ИспользованиеХарактеристик <> ЗНАЧЕНИЕ(Перечисление.ВариантыВеденияДополнительныхДанныхПоНоменклатуре.НеИспользовать)
	|				И ТаблицаТовары.Характеристика <> ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка))");

	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Результат = Запрос.Выполнить();

	ДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаДействующиеЦеныНоменклатуры", Результат.Выгрузить());

КонецПроцедуры

// Процедура печати документа.
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПереоценкаТоваров") Тогда
			УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
				КоллекцияПечатныхФорм,
				"ПереоценкаТоваров",
				НСтр("ru = 'Переоценка товаров'"),
				СформироватьПечатнуюФормуПереоценкиТоваров(МассивОбъектов, ОбъектыПечати, ПараметрыПечати));
	КонецЕсли;
	
КонецПроцедуры

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Переоценка товаров
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ПереоценкаТоваров";
	КомандаПечати.Представление = НСтр("ru = 'Переоценка товаров'");
	КомандаПечати.Обработчик = "УправлениеПечатьюРТКлиент.ОбработкаКомандыПечатиПереоценкиТоваров";
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	КомандаПечати.Порядок = 75;
	
	ДоступнаПечатьЭтикетокИЦенников = ПравоДоступа("Использование", Метаданные.Обработки.ПечатьЭтикетокИЦенников);
	
	Если ДоступнаПечатьЭтикетокИЦенников Тогда
		
		ПараметрыПечатиЦенников = УправлениеПечатьюРТ.СтруктураПараметровПечатиЦенниковИЭтикеток();
		ПараметрыПечатиЦенников.ИмяПроцедурыПодготовкиСтруктурыДанных = "УправлениеПечатьюРТВызовСервера.ПодготовитьСтруктуруДанныхЦенниковИЭтикетокДляПримененияЦен";
		ПараметрыПечатиЦенников.ИмяДокумента = "ПрименениеЦен";
		ПараметрыПечатиЦенников.УстановитьРежим = "ПечатьЦенников";
		
		ПараметрыПечатиЭтикеток = УправлениеПечатьюРТ.СтруктураПараметровПечатиЦенниковИЭтикеток();
		ПараметрыПечатиЭтикеток.ИмяПроцедурыПодготовкиСтруктурыДанных = "УправлениеПечатьюРТВызовСервера.ПодготовитьСтруктуруДанныхЦенниковИЭтикетокДляПримененияЦен";
		ПараметрыПечатиЭтикеток.ИмяДокумента = "ПрименениеЦен";
		ПараметрыПечатиЭтикеток.УстановитьРежим = "ПечатьЭтикеток";
	
		// Ценники
		КомандаПечати = КомандыПечати.Добавить();
		КомандаПечати.Идентификатор = "Ценники";
		КомандаПечати.Представление = НСтр("ru = 'Ценники'");
		КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;
		КомандаПечати.Обработчик = "УправлениеПечатьюРТКлиент.ОбработкаКомандыПечатиЦенниковИЭтикеток";
		КомандаПечати.ДополнительныеПараметры.Вставить("ПараметрыПечатиЦенниковИЭтикеток", ПараметрыПечатиЦенников);
		КомандаПечати.Порядок = 85;

		// Этикетки
		КомандаПечати = КомандыПечати.Добавить();
		КомандаПечати.Идентификатор = "Этикетки";
		КомандаПечати.Представление = НСтр("ru = 'Этикетки'");
		КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;
		КомандаПечати.Обработчик = "УправлениеПечатьюРТКлиент.ОбработкаКомандыПечатиЦенниковИЭтикеток";
		КомандаПечати.ДополнительныеПараметры.Вставить("ПараметрыПечатиЦенниковИЭтикеток", ПараметрыПечатиЭтикеток);
		КомандаПечати.Порядок = 85;
		
	КонецЕсли;
	
КонецПроцедуры

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
	
КонецПроцедуры

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(ОбъектЦенообразования)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

///////////////////////////////////////////////////////////////////////////////
// Печать

// Функция формирует табличный документ с печатной формой переоценки в рознице.
//
// Возвращаемое значение:
//  Табличный документ.
//
Функция СформироватьПечатнуюФормуПереоценкиТоваров(МассивОбъектов, ОбъектыПечати, ПараметрыПечати)
	
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ПереоценкаТоваров_ПереоценкаТоваров";
	
	ФормированиеПечатныхФормСервер.СформироватьПечатнуюФормуПереоценкиТоваров(МассивОбъектов, ОбъектыПечати, ПараметрыПечати, ТабДокумент);
	
	Возврат ТабДокумент;
	
КонецФункции

#КонецОбласти

#КонецЕсли
