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
	ВидыЦен = Товары.Выгрузить();
	ВидыЦен.Свернуть("ВидЦен");
	Для Каждого СтрокаТаблицы Из ВидыЦен Цикл
		
		Если Не ЗначениеЗаполнено(СтрокаТаблицы.ВидЦен) Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаТаб = Таблица.Добавить();
		СтрокаТаб.ЗначениеДоступа = СтрокаТаблицы.ВидЦен;
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

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если НЕ ЗначениеЗаполнено(Операция) Тогда
		МассивНепроверяемыхРеквизитов = Новый Массив;
		МассивНепроверяемыхРеквизитов.Добавить("Стадия");
		ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	КонецЕсли;
	
	Если НЕ АссортиментСервер.ВидыЦенИзмененияАссортиментаСоответствуютПравилам(ЭтотОбъект) Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ЭтоНовый() Тогда
		Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
			
			ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
			
		КонецЕсли;
		ИнициализироватьДокумент();
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Ответственный = Пользователи.ТекущийПользователь();
	ПроверитьДоступностьОбъектаПланированияПриЗаполнении();
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеСервер.УстановитьРежимПроведения(Проведен, РежимЗаписи, РежимПроведения);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	Документы.ИзменениеАссортимента.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	АссортиментСервер.ОтразитьАссортимент(ДополнительныеСвойства, Движения, Отказ);
	
	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Инициализирует документ
//
Процедура ИнициализироватьДокумент()
	
	Ответственный		 = Пользователи.ТекущийПользователь();
	ОбъектПланирования	 = ЗначениеНастроекПовтИсп.ПолучитьФорматМагазинаПоУмолчанию(ОбъектПланирования);
	ПроверитьДоступностьОбъектаПланированияПриЗаполнении();
	
КонецПроцедуры

Процедура ПроверитьДоступностьОбъектаПланированияПриЗаполнении()
	
	ДоступностьПравила = ОбщегоНазначенияРТВызовСервера.ПроверитьДоступКРеквизиту(
								ОбъектПланирования,
								"ПравилоЦенообразования",
								"Справочник.ПравилаЦенообразования");
	Если НЕ ДоступностьПравила Тогда
		ОбъектПланирования = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
