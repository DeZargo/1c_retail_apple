﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Процедура ЗаполнитьНаборыЗначенийДоступа заполняет наборы значений доступа
// по объекту в таблице с полями:
//  - НомерНабора     Число                                     (необязательно, если набор один),
//  - ВидДоступа      ПланВидовХарактеристикСсылка.ВидыДоступа, (обязательно),
//  - ЗначениеДоступа Неопределено, СправочникСсылка или др.    (обязательно),
//  - Чтение          Булево (необязательно, если набор для всех прав; устанавливается для одной строки набора),
//  - Добавление      Булево (необязательно, если набор для всех прав; устанавливается для одной строки набора),
//  - Изменение       Булево (необязательно, если набор для всех прав; устанавливается для одной строки набора),
//  - Удаление        Булево (необязательно, если набор для всех прав; устанавливается для одной строки набора).
//
//  Вызывается из процедуры УправлениеДоступом.ЗаписатьНаборыЗначенийДоступа(),
// если объект зарегистрирован в "ПодпискаНаСобытие.ЗаписатьНаборыЗначенийДоступа" и
// из таких же процедур объектов, у которых наборы значений доступа зависят от наборов этого
// объекта (в этом случае объект зарегистрирован в "ПодпискаНаСобытие.ЗаписатьЗависимыеНаборыЗначенийДоступа").
//
// Параметры:
//  Таблица      - ТабличнаяЧасть,
//                 РегистрСведенийНаборЗаписей.НаборыЗначенийДоступа,
//                 ТаблицаЗначений, возвращаемая УправлениеДоступом.ТаблицаНаборыЗначенийДоступа().
//
Процедура ЗаполнитьНаборыЗначенийДоступа(Таблица) Экспорт
	
	// Логика ограничения следующая:
	// объект доступен, если доступны все виды цен.
	// 
	
	Для Каждого СтрокаТаблицы Из ВидыЦен Цикл
		
		Если Не ЗначениеЗаполнено(СтрокаТаблицы.ВидЦены) Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаТаб = Таблица.Добавить();
		СтрокаТаб.ЗначениеДоступа = СтрокаТаблицы.ВидЦены;
	КонецЦикла;
	
	Если Таблица.Количество() = 0 Тогда
	
		СтрокаТаб = Таблица.Добавить();
		СтрокаТаб.Чтение          = Истина;
		СтрокаТаб.Изменение       = Истина;
		СтрокаТаб.ЗначениеДоступа = Справочники.ВидыЦен.ПустаяСсылка();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоНовый()
		И ЗначениеЗаполнено(ДокументОснование)
		И (ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.ПоступлениеТоваров")
			ИЛИ ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.ПеремещениеТоваров")
			ИЛИ ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.ОприходованиеТоваров")) Тогда
			ДатаОснования = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументОснование, "Дата");
			Если НачалоДня(Дата) = НачалоДня(ДатаОснования) Тогда
				Дата = ДатаОснования - 1;
			КонецЕсли;
	КонецЕсли;

	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	Ценообразование.ИзменитьПризнакСогласованностиДокумента(ЭтотОбъект, РежимЗаписи);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если (НЕ Пользователи.РолиДоступны("ДобавлениеИзменениеЦенНоменклатуры"))
		И (НЕ Пользователи.РолиДоступны("ПолныеПрава")) Тогда
				
		ТекстОшибки = НСтр("ru = 'Нет прав на установку цен номенклатуры'");
		
		ОбщегоНазначения.СообщитьПользователю(
			ТекстОшибки,
			ЭтотОбъект,
			,
			,
			Отказ);
			
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ИнициализироватьДокумент();
	ЦенообразованиеПереопределяемый.ОбработкаЗаполненияУстановкиЦенНоменклатуры(
		ЭтотОбъект,
		ДанныеЗаполнения,
		СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
    
    // &ЗамерПроизводительности
    ВремяНачалаЗамера = ОценкаПроизводительности.НачатьЗамерВремени();

	Ценообразование.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);

	Документы.УстановкаЦенНоменклатуры.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);

	Ценообразование.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);

	Ценообразование.ОтразитьЦеныНоменклатуры(ДополнительныеСвойства, Движения, Отказ);

	Ценообразование.ЗаписатьНаборыЗаписей(ЭтотОбъект);
    
    ОценкаПроизводительности.ЗакончитьЗамерВремени("УстановкаЦенНоменклатурыПроведение",ВремяНачалаЗамера,Товары.Количество(), "Вес по табличной части ""Товары""");

КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)

	Ценообразование.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);

	Ценообразование.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);

	Ценообразование.ЗаписатьНаборыЗаписей(ЭтотОбъект);

КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ИнициализироватьДокумент();
	Согласован = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Инициализирует установку цен номенклатуры.
//
Процедура ИнициализироватьДокумент()

	Ответственный = Пользователи.ТекущийПользователь();

КонецПроцедуры

#КонецОбласти

#КонецЕсли
