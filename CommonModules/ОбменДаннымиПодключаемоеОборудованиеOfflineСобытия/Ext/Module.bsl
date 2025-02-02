﻿
#Область ПрограммныйИнтерфейс

// Зарегистрировать изменения справочников.
//
Процедура ЗарегистрироватьИзмененияСправочника(Источник, Отказ) Экспорт

	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеНастроекПовтИсп.ПолучитьЗначениеКонстанты("ИспользоватьОбменСПодключаемымОборудованием") Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТипИсточника = ТипЗнч(Источник);
	Если ТипИсточника = Тип("СправочникОбъект.Номенклатура") Тогда
		
		Запрос = Новый Запрос(   
		"ВЫБРАТЬ
		|	КодыТоваровPLUНаОборудовании.КодТовараPLU,
		|	КодыТоваровPLUНаОборудовании.ПравилоОбмена КАК ПравилоОбмена,
		|	ПодключаемоеОборудование.УзелИнформационнойБазы КАК УзелИнформационнойБазы
		|ИЗ
		|	РегистрСведений.КодыТоваровSKU КАК КодыТоваровSKU
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.КодыТоваровPLUНаОборудовании КАК КодыТоваровPLUНаОборудовании
		|		ПО (КодыТоваровPLUНаОборудовании.КодТовараSKU = КодыТоваровSKU.SKU)
		|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПодключаемоеОборудование КАК ПодключаемоеОборудование
		|		ПО КодыТоваровPLUНаОборудовании.ПравилоОбмена = ПодключаемоеОборудование.ПравилоОбмена
		|	ГДЕ
		|		ПодключаемоеОборудование.УзелИнформационнойБазы <> ЗНАЧЕНИЕ(ПланОбмена.ОбменСПодключаемымОборудованием.ПустаяСсылка)
		|		И КодыТоваровSKU.Номенклатура = &Значение");
		
	ИначеЕсли ТипИсточника = Тип("СправочникОбъект.ХарактеристикиНоменклатуры") Тогда
		
		Запрос = Новый Запрос(   
		"ВЫБРАТЬ
		|	КодыТоваровPLUНаОборудовании.КодТовараPLU,
		|	КодыТоваровPLUНаОборудовании.ПравилоОбмена КАК ПравилоОбмена,
		|	ПодключаемоеОборудование.УзелИнформационнойБазы КАК УзелИнформационнойБазы
		|ИЗ
		|	РегистрСведений.КодыТоваровSKU КАК КодыТоваровSKU
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.КодыТоваровPLUНаОборудовании КАК КодыТоваровPLUНаОборудовании
		|		ПО (КодыТоваровPLUНаОборудовании.КодТовараSKU = КодыТоваровSKU.SKU)
		|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПодключаемоеОборудование КАК ПодключаемоеОборудование
		|		ПО КодыТоваровPLUНаОборудовании.ПравилоОбмена = ПодключаемоеОборудование.ПравилоОбмена
		|	ГДЕ
		|		ПодключаемоеОборудование.УзелИнформационнойБазы <> ЗНАЧЕНИЕ(ПланОбмена.ОбменСПодключаемымОборудованием.ПустаяСсылка)
		|		И КодыТоваровSKU.Характеристика = &Значение");
		
	ИначеЕсли ТипИсточника = Тип("СправочникОбъект.УпаковкиНоменклатуры") Тогда
		
		Запрос = Новый Запрос(   
		"ВЫБРАТЬ
		|	КодыТоваровPLUНаОборудовании.КодТовараPLU,
		|	КодыТоваровPLUНаОборудовании.ПравилоОбмена КАК ПравилоОбмена,
		|	ПодключаемоеОборудование.УзелИнформационнойБазы КАК УзелИнформационнойБазы
		|ИЗ
		|	РегистрСведений.КодыТоваровSKU КАК КодыТоваровSKU
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.КодыТоваровPLUНаОборудовании КАК КодыТоваровPLUНаОборудовании
		|		ПО (КодыТоваровPLUНаОборудовании.КодТовараSKU = КодыТоваровSKU.SKU)
		|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПодключаемоеОборудование КАК ПодключаемоеОборудование
		|		ПО КодыТоваровPLUНаОборудовании.ПравилоОбмена = ПодключаемоеОборудование.ПравилоОбмена
		|	ГДЕ
		|		ПодключаемоеОборудование.УзелИнформационнойБазы <> ЗНАЧЕНИЕ(ПланОбмена.ОбменСПодключаемымОборудованием.ПустаяСсылка)
		|		И КодыТоваровSKU.Упаковка = &Значение");
		
	ИначеЕсли ТипИсточника = Тип("СправочникОбъект.ВидыНоменклатуры") Тогда  
		
		Запрос = Новый Запрос(   
		"ВЫБРАТЬ
		|	КодыТоваровPLUНаОборудовании.КодТовараPLU,
		|	КодыТоваровPLUНаОборудовании.ПравилоОбмена КАК ПравилоОбмена,
		|	ПодключаемоеОборудование.УзелИнформационнойБазы КАК УзелИнформационнойБазы
		|ИЗ
		|	РегистрСведений.КодыТоваровSKU КАК КодыТоваровSKU
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.КодыТоваровPLUНаОборудовании КАК КодыТоваровPLUНаОборудовании
		|		ПО (КодыТоваровPLUНаОборудовании.КодТовараSKU = КодыТоваровSKU.SKU)
		|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПодключаемоеОборудование КАК ПодключаемоеОборудование
		|		ПО КодыТоваровPLUНаОборудовании.ПравилоОбмена = ПодключаемоеОборудование.ПравилоОбмена
		|	ГДЕ
		|		ПодключаемоеОборудование.УзелИнформационнойБазы <> ЗНАЧЕНИЕ(ПланОбмена.ОбменСПодключаемымОборудованием.ПустаяСсылка)
		|		И КодыТоваровSKU.Номенклатура.ВидНоменклатуры = &Значение");
		
	ИначеЕсли ТипИсточника = Тип("СправочникОбъект.ПодключаемоеОборудование") Тогда
		
		Если  ЗначениеЗаполнено(Источник.УзелИнформационнойБазы)
			И ЗначениеЗаполнено(Источник.ПравилоОбмена)
			И Источник.ПравилоОбмена <> Источник.Ссылка.ПравилоОбмена
			И (Источник.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ККМОфлайн
			   ИЛИ Источник.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ВесыСПечатьюЭтикеток) Тогда
			
			ПланыОбмена.УдалитьРегистрациюИзменений(Источник.УзелИнформационнойБазы);
			
			Запрос = Новый Запрос(
			"ВЫБРАТЬ
			|	КодыТоваровPLUНаОборудовании.ПравилоОбмена КАК ПравилоОбмена,
			|	КодыТоваровPLUНаОборудовании.КодТовараPLU  КАК КодТовараPLU
			|	&УзелИнформационнойБазы                    КАК УзелИнформационнойБазы
			|ИЗ
			|	РегистрСведений.КодыТоваровPLUНаОборудовании КАК КодыТоваровPLUНаОборудовании
			|ГДЕ
			|	КодыТоваровPLUНаОборудовании.ПравилоОбмена = &ПравилоОбмена");
			
			Запрос.УстановитьПараметр("ПравилоОбмена", Источник.ПравилоОбмена);
			Запрос.УстановитьПараметр("УзелИнформационнойБазы", Источник.УзелИнформационнойБазы);
		Иначе
			Возврат;
		КонецЕсли;
		
	Иначе
		Возврат;
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Значение",             Источник.Ссылка);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Набор = РегистрыСведений.КодыТоваровPLUНаОборудовании.СоздатьНаборЗаписей();
	Пока Выборка.Следующий() Цикл
		
		Набор.Отбор.ПравилоОбмена.Значение = Выборка.ПравилоОбмена;
		Набор.Отбор.ПравилоОбмена.Использование = Истина;
		
		Набор.Отбор.КодТовараPLU.Значение = Выборка.КодТовараPLU;
		Набор.Отбор.КодТовараPLU.Использование = Истина;
		
		ПланыОбмена.ЗарегистрироватьИзменения(Выборка.УзелИнформационнойБазы, Набор);
	
	КонецЦикла;
	
КонецПроцедуры

// Зарегистрировать изменения в документах.
//
Процедура ЗарегистрироватьИзмененияДокумента(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеНастроекПовтИсп.ПолучитьЗначениеКонстанты("ИспользоватьОбменСПодключаемымОборудованием") Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТипИсточника = ТипЗнч(Источник);
	Если ТипИсточника = Тип("ДокументОбъект.УстановкаЦенНоменклатуры") Тогда
		
		Запрос = Новый Запрос(
		
		"ВЫБРАТЬ
		|	КодыТоваровSKU.Номенклатура,
		|	КодыТоваровSKU.Характеристика,
		|	КодыТоваровSKU.Упаковка,
		|	КодыТоваровPLUНаОборудовании.КодТовараPLU,
		|	КодыТоваровPLUНаОборудовании.ПравилоОбмена КАК ПравилоОбмена,
		|	ПодключаемоеОборудование.УзелИнформационнойБазы КАК УзелИнформационнойБазы
		|ИЗ
		|	РегистрСведений.КодыТоваровSKU КАК КодыТоваровSKU
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.КодыТоваровPLUНаОборудовании КАК КодыТоваровPLUНаОборудовании
		|		ПО (КодыТоваровPLUНаОборудовании.КодТовараSKU = КодыТоваровSKU.SKU)
		|	
		|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПодключаемоеОборудование КАК ПодключаемоеОборудование
		|		ПО КодыТоваровPLUНаОборудовании.ПравилоОбмена = ПодключаемоеОборудование.ПравилоОбмена
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.УстановкаЦенНоменклатуры.Товары КАК УстановкаЦенНоменклатурыТовары
		|		ПО КодыТоваровSKU.Номенклатура = УстановкаЦенНоменклатурыТовары.Номенклатура
		|		И КодыТоваровSKU.Характеристика = УстановкаЦенНоменклатурыТовары.Характеристика
		|	ГДЕ
		|		ПодключаемоеОборудование.УзелИнформационнойБазы <> ЗНАЧЕНИЕ(ПланОбмена.ОбменСПодключаемымОборудованием.ПустаяСсылка)
		|		И УстановкаЦенНоменклатурыТовары.Ссылка = &Значение");
		
		Запрос.УстановитьПараметр("Значение", Источник.Ссылка);
		
		Результат = Запрос.Выполнить();
		Выборка = Результат.Выбрать();
		
		Набор = РегистрыСведений.КодыТоваровPLUНаОборудовании.СоздатьНаборЗаписей();
		Пока Выборка.Следующий() Цикл
			
			Набор.Отбор.ПравилоОбмена.Значение = Выборка.ПравилоОбмена;
			Набор.Отбор.ПравилоОбмена.Использование = Истина;
			
			Набор.Отбор.КодТовараPLU.Значение = Выборка.КодТовараPLU;
			Набор.Отбор.КодТовараPLU.Использование = Истина;
			
			ПланыОбмена.ЗарегистрироватьИзменения(Выборка.УзелИнформационнойБазы, Набор);
			
		КонецЦикла;
		
	ИначеЕсли ТипИсточника = Тип("ДокументОбъект.ЗаказПокупателя") Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗаказПокупателя.Ссылка КАК Ссылка,
		|	ЗаказПокупателя.КассаККМ КАК КассаККМ,
		|	ЗаказПокупателя.КассаККМ.ПодключаемоеОборудование.УзелИнформационнойБазы КАК УзелИнформационнойБазы
		|ИЗ
		|	Документ.ЗаказПокупателя КАК ЗаказПокупателя
		|ГДЕ
		|	ЗаказПокупателя.КассаККМ <> ЗНАЧЕНИЕ(Справочник.КассыККМ.ПустаяСсылка)
		|	И ЗаказПокупателя.Ссылка = &Ссылка";
		
		Запрос.УстановитьПараметр("Ссылка", Источник.Ссылка);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		Выборка = РезультатЗапроса.Выбрать();
		
		Если Выборка.Следующий() Тогда
			
			ПланыОбмена.ЗарегистрироватьИзменения(Выборка.УзелИнформационнойБазы, Выборка.Ссылка);
			
		КонецЕсли;
		
		
	ИначеЕсли ТипИсточника = Тип("ДокументОбъект.ПриходныйКассовыйОрдер") Тогда
		
		Если ЗначениеЗаполнено(Источник.ЗаказПокупателя) Тогда
			
			Запрос = Новый Запрос;
			Запрос.Текст = 
			"ВЫБРАТЬ
			|	Ордер.ЗаказПокупателя КАК ЗаказПокупателя,
			|	Ордер.ЗаказПокупателя.КассаККМ.ПодключаемоеОборудование.УзелИнформационнойБазы КАК УзелИнформационнойБазы
			|ИЗ
			|	Документ.ПриходныйКассовыйОрдер КАК Ордер
			|ГДЕ
			|	Ордер.Ссылка = &Ссылка
			|	И НЕ Ордер.ЗаказПокупателя.КассаККМ.ПодключаемоеОборудование.УзелИнформационнойБазы ЕСТЬ NULL";
			
			Запрос.УстановитьПараметр("Ссылка", Источник.Ссылка);
			
			РезультатЗапроса = Запрос.Выполнить();
			
			Выборка = РезультатЗапроса.Выбрать();
			
			Если Выборка.Следующий() Тогда
				
				ПланыОбмена.ЗарегистрироватьИзменения(Выборка.УзелИнформационнойБазы, Выборка.ЗаказПокупателя);
				
			КонецЕсли;
			
		КонецЕсли;
		
	ИначеЕсли ТипИсточника = Тип("ДокументОбъект.РасходныйКассовыйОрдер") Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	РасходныйКассовыйОрдерРасшифровкаПлатежа.Ссылка КАК Ссылка,
		|	ВЫРАЗИТЬ(РасходныйКассовыйОрдерРасшифровкаПлатежа.ДокументРасчетовСКонтрагентом КАК Документ.ПриходныйКассовыйОрдер) КАК ПриходныйКассовыйОрдер
		|ПОМЕСТИТЬ РасшифровкаПлатежа
		|ИЗ
		|	Документ.РасходныйКассовыйОрдер.РасшифровкаПлатежа КАК РасходныйКассовыйОрдерРасшифровкаПлатежа
		|ГДЕ
		|	РасходныйКассовыйОрдерРасшифровкаПлатежа.Ссылка = &Ссылка
		|	И РасходныйКассовыйОрдерРасшифровкаПлатежа.ДокументРасчетовСКонтрагентом ССЫЛКА Документ.ПриходныйКассовыйОрдер
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	РасшифровкаПлатежа.ПриходныйКассовыйОрдер.ЗаказПокупателя КАК ЗаказПокупателя,
		|	РасшифровкаПлатежа.ПриходныйКассовыйОрдер.ЗаказПокупателя.КассаККМ.ПодключаемоеОборудование.УзелИнформационнойБазы КАК УзелИнформационнойБазы
		|ИЗ
		|	РасшифровкаПлатежа КАК РасшифровкаПлатежа
		|ГДЕ
		|	НЕ РасшифровкаПлатежа.ПриходныйКассовыйОрдер.ЗаказПокупателя.КассаККМ.ПодключаемоеОборудование.УзелИнформационнойБазы ЕСТЬ NULL";
		
		Запрос.УстановитьПараметр("Ссылка", Источник.Ссылка);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		Выборка = РезультатЗапроса.Выбрать();
		
		Если Выборка.Следующий() Тогда
			
			ПланыОбмена.ЗарегистрироватьИзменения(Выборка.УзелИнформационнойБазы, Выборка.ЗаказПокупателя);
			
		КонецЕсли;
		
	ИначеЕсли ТипИсточника = Тип("ДокументОбъект.ОплатаОтПокупателяПлатежнойКартой") Тогда
		
		Если ЗначениеЗаполнено(Источник.ЗаказПокупателя) Тогда
			
			Запрос = Новый Запрос;
			Запрос.Текст = 
			"ВЫБРАТЬ
			|	ОплатаКартой.ЗаказПокупателя КАК ЗаказПокупателя,
			|	ОплатаКартой.ЗаказПокупателя.КассаККМ.ПодключаемоеОборудование.УзелИнформационнойБазы КАК УзелИнформационнойБазы
			|ИЗ
			|	Документ.ОплатаОтПокупателяПлатежнойКартой КАК ОплатаКартой
			|ГДЕ
			|	ОплатаКартой.Ссылка = &Ссылка
			|	И НЕ ОплатаКартой.ЗаказПокупателя.КассаККМ.ПодключаемоеОборудование.УзелИнформационнойБазы ЕСТЬ NULL";
			
			Запрос.УстановитьПараметр("Ссылка", Источник.Ссылка);
			
			РезультатЗапроса = Запрос.Выполнить();
			
			Выборка = РезультатЗапроса.Выбрать();
			
			Если Выборка.Следующий() Тогда
				
				ПланыОбмена.ЗарегистрироватьИзменения(Выборка.УзелИнформационнойБазы, Выборка.ЗаказПокупателя);
				
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

// Зарегистрировать изменения регистра сведений.
//
Процедура ЗарегистрироватьИзмененияРегистраСведений(Источник, Отказ, Замещение) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеНастроекПовтИсп.ПолучитьЗначениеКонстанты("ИспользоватьОбменСПодключаемымОборудованием") Тогда
		Возврат;
	КонецЕсли;

	УстановитьПривилегированныйРежим(Истина);
	
	ТипИсточника = ТипЗнч(Источник);
	Если ТипИсточника = Тип("РегистрСведенийНаборЗаписей.Штрихкоды") Тогда
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|КодыТоваровPLUНаОборудовании.КодТовараPLU,
		|КодыТоваровPLUНаОборудовании.ПравилоОбмена КАК ПравилоОбмена,
		|ПодключаемоеОборудование.УзелИнформационнойБазы КАК УзелИнформационнойБазы
		|ИЗ
		|	РегистрСведений.КодыТоваровSKU КАК КодыТоваровSKU
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.КодыТоваровPLUНаОборудовании КАК КодыТоваровPLUНаОборудовании
		|		ПО (КодыТоваровPLUНаОборудовании.КодТовараSKU = КодыТоваровSKU.SKU)
		|	
		|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПодключаемоеОборудование КАК ПодключаемоеОборудование
		|		ПО КодыТоваровPLUНаОборудовании.ПравилоОбмена = ПодключаемоеОборудование.ПравилоОбмена
		|
		|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.Штрихкоды КАК Штрихкоды
		|		ПО КодыТоваровSKU.Номенклатура = Штрихкоды.Владелец
		|			И КодыТоваровSKU.Характеристика = Штрихкоды.Характеристика
		|			И КодыТоваровSKU.Упаковка = Штрихкоды.Упаковка
		|ГДЕ
		|	ПодключаемоеОборудование.УзелИнформационнойБазы <> ЗНАЧЕНИЕ(ПланОбмена.ОбменСПодключаемымОборудованием.ПустаяСсылка)
		|	И Штрихкоды.Штрихкод = &Значение");
		
		Запрос.УстановитьПараметр("Значение", Источник.Отбор.Штрихкод.Значение);
	Иначе
		Возврат;
	КонецЕсли;
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Набор = РегистрыСведений.КодыТоваровPLUНаОборудовании.СоздатьНаборЗаписей();
	Пока Выборка.Следующий() Цикл
		
		Набор.Отбор.ПравилоОбмена.Значение = Выборка.ПравилоОбмена;
		Набор.Отбор.ПравилоОбмена.Использование = Истина;
		
		Набор.Отбор.КодТовараPLU.Значение = Выборка.КодТовараPLU;
		Набор.Отбор.КодТовараPLU.Использование = Истина;
		
		ПланыОбмена.ЗарегистрироватьИзменения(Выборка.УзелИнформационнойБазы, Набор);
	
	КонецЦикла;
	
КонецПроцедуры

// Создать узел обмена с подключаемым оборудованием Offline.
//
Процедура СоздатьУзелОбменаСПодключаемымОборудованиемOffline(Источник, Отказ) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Источник.УзелИнформационнойБазы)
		И (Источник.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ККМОфлайн
		ИЛИ Источник.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ВесыСПечатьюЭтикеток
		ИЛИ Источник.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.УдалитьWebСервисОборудование) Тогда
		
		Источник.УзелИнформационнойБазы = ПолучитьУзелРИБ(Источник);
	КонецЕсли;
	
	Источник.ДополнительныеСвойства.Вставить("ИзмененоПравилоОбмена", Источник.ПравилоОбмена <> Источник.Ссылка.ПравилоОбмена);
	
КонецПроцедуры

// Очистить узел обмена с подключаемым оборудованием Offline.
//
Процедура ОчиститьУзелОбменаСПодключаемымОборудованиемOffline(Источник, ОбъектКопирования) Экспорт
	
	Источник.УзелИнформационнойБазы = ПланыОбмена.ОбменСПодключаемымОборудованием.ПустаяСсылка();
	
КонецПроцедуры

// Зарегистрировать изменения при смене правила обмена подключаемого оборудования.
//
Процедура ЗарегистрироватьИзмененияПриСменеПравилаОбменаПодключаемогоОборудования(Источник, Отказ) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если (Источник.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ККМОфлайн
		ИЛИ Источник.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ВесыСПечатьюЭтикеток)
		И Источник.ДополнительныеСвойства.ИзмененоПравилоОбмена Тогда
		
		УстановитьПривилегированныйРежим(Истина);
		ПланыОбмена.ЗарегистрироватьИзменения(Источник.УзелИнформационнойБазы, Метаданные.РегистрыСведений.КодыТоваровPLUНаОборудовании);
		
	КонецЕсли;
	
КонецПроцедуры

// Зарегистрировать изменения регистра накоплений.
//
Процедура ЗарегистрироватьИзмененияРегистраНакопленияДляОбменаСОборудованиемOfflineПриЗаписи(Источник, Отказ, Замещение) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписьюРегистра("ОбменСПодключаемымОборудованием", Источник, Отказ, Замещение);
	
КонецПроцедуры

// Функция создает узел для данного экземпляра подключаемого оборудования и возвращает ссылку на него.
// Применяется перед записью элемента справочника Подключаемое оборудование.
//
Функция ПолучитьУзелРИБ(ПодключаемоеОборудованиеОбъект)
	
	УзелОбъект = ПланыОбмена.ОбменСПодключаемымОборудованием.СоздатьУзел();
	УзелОбъект.УстановитьНовыйКод();
	УзелОбъект.Наименование = ПодключаемоеОборудованиеОбъект.Наименование;
	УзелОбъект.Записать();
	
	Возврат УзелОбъект.Ссылка;
	
КонецФункции

#КонецОбласти
