﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ПроведениеСервер.УстановитьРежимПроведения(Проведен, РежимЗаписи, РежимПроведения);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.ИнтервалыРаботыМагазинов") Тогда
		
		ДатаОтчета			 = НачалоДня(ТекущаяДатаСеанса());
		Магазин				 = ДанныеЗаполнения.Магазин;
		РабочаяСмена		 = ДанныеЗаполнения;
		
		Документы.ЕжедневныйОтчет.ЗаполнитьТабличнуюЧастьСотрудникиСмены(ЭтотОбъект);
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
		
	КонецЕсли;
	
	ИнициализироватьДокумент();
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	Документы.ЕжедневныйОтчет.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ОтразитьФактическоеРабочееВремяСотрудников(ДополнительныеСвойства, Движения, Отказ);
	
	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ИнициализироватьДокумент();
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	// Проверка на дублирование сотрудников.
	МассивСтрок = СтрокиДублированияСотрудниковВДокументе();
	Для Каждого ТекущаяСтрока Из МассивСтрок Цикл
		
		ТекстОшибки = НСтр("ru = 'В строках %Стр1% и %Стр2%
			|обнаружено дублирование сотрудников'");
			
		ТекстОшибки = СтрЗаменить(ТекстОшибки,"%Стр1%",ТекущаяСтрока.Стр1);
		ТекстОшибки = СтрЗаменить(ТекстОшибки,"%Стр2%",ТекущаяСтрока.Стр2);
		ОбщегоНазначения.СообщитьПользователю(
			ТекстОшибки,
			,
			"Объект.ОтработанноеВремя",
			,
			Отказ);
			
	КонецЦикла;
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ИнициализироватьДокумент()
	
	Ответственный = Пользователи.ТекущийПользователь();
	Магазин = ЗначениеНастроекПовтИсп.ПолучитьМагазинПоУмолчанию(Магазин);

	//Если НЕ ЗначениеЗаполнено(Сотрудник) Тогда
	//	Сотрудник = Ответственный.ФизЛицо;
	//КонецЕсли;
	
	//Если НЕ Сотрудник.Сотрудник ИЛИ НЕ Сотрудник.Магазин = Магазин Тогда
		Сотрудник = Справочники.ФизическиеЛица.ПустаяСсылка();
	//КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ДатаОтчета) Тогда
		
		ДатаОтчета = ТекущаяДатаСеанса();
		
	КонецЕсли;
	
КонецПроцедуры

Функция СтрокиДублированияСотрудниковВДокументе()
	
	Результат = Новый Массив;
	ПарыСтрок = Новый Структура("Стр1, Стр2");
	
	Для Каждого ТекСтрока Из ОтработанноеВремя Цикл
		Для Каждого ТекСтрокаВнутр Из ОтработанноеВремя Цикл
			Если ТекСтрока <> ТекСтрокаВнутр
				И ТекСтрока.Сотрудник = ТекСтрокаВнутр.Сотрудник
			Тогда
				ПарыСтрок.Вставить("Стр1", ТекСтрока.НомерСтроки);
				ПарыСтрок.Вставить("Стр2", ТекСтрокаВнутр.НомерСтроки);
				Если Результат.Найти(ПарыСтрок) = Неопределено Тогда
					Результат.Добавить(ПарыСтрок);
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Процедура ОтразитьФактическоеРабочееВремяСотрудников (ДополнительныеСвойства, Движения, Отказ)
	
	Таблица = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаФактическоеРабочееВремяСотрудников;
	
	Если Отказ ИЛИ Таблица.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;

	Движения.ФактическоеРабочееВремяСотрудников.Записывать = Истина;
	Движения.ФактическоеРабочееВремяСотрудников.Загрузить(Таблица);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
