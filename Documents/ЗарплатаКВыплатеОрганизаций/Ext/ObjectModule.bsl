﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.РасчетПремийПоЛичнымПродажам") Тогда
		
		ОбщегоНазначенияРТ.ПроверитьВозможностьВводаНаОсновании(ДанныеЗаполнения);

		ДокументОснование = ДанныеЗаполнения;
		Магазин = ДанныеЗаполнения.Магазин;
		Ответственный = ДанныеЗаполнения.Ответственный;
		ПериодРегистрации = ДанныеЗаполнения.Дата;
		Для Каждого ТекСтрокаСотрудники Из ДанныеЗаполнения.Сотрудники Цикл
			НоваяСтрока = Зарплата.Добавить();
			НоваяСтрока.Сумма = ТекСтрокаСотрудники.СуммаПремии;
			НоваяСтрока.СуммаВыплаты = ТекСтрокаСотрудники.СуммаПремии;
			НоваяСтрока.ФизЛицо = ТекСтрокаСотрудники.ФизЛицо;
			НоваяСтрока.ОтметкаОВыплатеЗарплаты = Перечисления.ВариантыОтметокОВыплатеЗарплаты.НеВыплачено;
		КонецЦикла;
	КонецЕсли;
	
	ДанныеЗаполнения = Новый Структура();
	ДанныеЗаполнения.Вставить("Организация", ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ТекущаяОрганизация",""));
	ДанныеЗаполнения.Вставить("Касса");
	ДанныеЗаполнения.Вставить("Магазин");
	ДенежныеСредстваСервер.ЗаполнитьРеквизитыДокументаПоФормеОплаты(ДанныеЗаполнения, Перечисления.ФормыОплаты.Наличная);
	Если ЗначениеЗаполнено(ДанныеЗаполнения.Касса) Тогда
		ДанныеЗаполнения.Вставить("Магазин", ДенежныеСредстваСервер.ПолучитьРеквизитыКассы(ДанныеЗаполнения.Касса).Магазин);
	КонецЕсли;
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	ОбщегоНазначенияРТ.ПроверитьИспользованиеОрганизации(,,Организация);
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	Если Пользователи.РолиДоступны("ИзменениеЗарплатыКВыплатеОрганизаций") 
	И НЕ Пользователи.РолиДоступны("ДобавлениеИзменениеЗарплатыКВыплатеОрганизаций")
	И НЕ Пользователи.РолиДоступны("ПолныеПрава") Тогда

		ПроверитьВозможностьЗаписи(Отказ, РежимЗаписи);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ИнициализироватьДокумент();
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	МассивРезультатовЗапросов = Документы.ЗарплатаКВыплатеОрганизаций.ДанныеОВыплатеПоВедомости(ЭтотОбъект);
	Выборка = МассивРезультатовЗапросов[1].Выбрать();
	ВыборкаВедомостьОплачена = МассивРезультатовЗапросов[2].Выбрать();
	
	Если ВыборкаВедомостьОплачена.Следующий() Тогда
		Если ВыборкаВедомостьОплачена.ВедомостьОплаченаПолностью
			ИЛИ ВыборкаВедомостьОплачена.ВедомостьОплаченаНеПолностью Тогда
			Текст = НСтр("ru = 'По ведомости оформлены расходные кассовые ордера, отмена проведения невозможна!'");
			ОбщегоНазначения.СообщитьПользователю(
				Текст,
				ЭтотОбъект,
				,
				,
				Отказ);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПроверитьВозможностьЗаписи(Отказ, РежимЗаписи)

	Если НЕ Проведен Тогда
		
		Текст = НСтр("ru = 'Недостаточно прав для выполнения операции.'");
		
		ОбщегоНазначения.СообщитьПользователю(Текст, ЭтотОбъект, , , Отказ);
		
	КонецЕсли;

КонецПроцедуры

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Ответственный = Пользователи.ТекущийПользователь();
	Магазин       = ЗначениеНастроекПовтИсп.ПолучитьМагазинПоУмолчанию(Магазин);
	Организация   = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация,Ответственный);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
