﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)

	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект,ДанныеЗаполнения);
	КонецЕсли;
	
	Ответственный = Пользователи.ТекущийПользователь();
	Склад         = ЗначениеНастроекПовтИсп.ПолучитьСкладПоступленияПоУмолчанию(Магазин,,Склад, Ответственный);
	
	ОбщегоНазначенияРТ.ПроверитьИспользованиеОрганизации(,,Организация);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеСервер.УстановитьРежимПроведения(Проведен, РежимЗаписи, РежимПроведения);

	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	Если ДатаНачала > ДатаОкончания Тогда
		ТекстСообщения = НСтр("ru='Дата начала инвентаризации должна быть меньше или равна дате окончания инвентаризации.'");
		
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,,"ДатаНачала","Объект",Отказ);
	КонецЕсли;
	
	ЗапасыСервер.ПроверитьВыполнениеПересчетаТоваров(
		ЭтотОбъект,
		Отказ);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Статус = Перечисления.СтатусыПриказовНаПроведениеИнвентаризацийТоваров.ВРаботе;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
