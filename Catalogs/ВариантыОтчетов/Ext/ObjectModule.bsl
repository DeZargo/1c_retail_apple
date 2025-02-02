﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	ИсключаемыеРеквизиты = Новый Массив;
	
	Если Не Пользовательский Тогда
		ИсключаемыеРеквизиты.Добавить("Автор");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, ИсключаемыеРеквизиты);
	
	Если Наименование <> "" И ВариантыОтчетов.НаименованиеЗанято(Отчет, Ссылка, Наименование) Тогда
		Отказ = Истина;
		ОбщегоНазначения.СообщитьПользователю(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '""%1"" занято, необходимо указать другое наименование.'"), Наименование),
			,
			"Наименование");
	КонецЕсли;
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	Если ДополнительныеСвойства.Свойство("ЗаполнениеПредопределенных") Тогда
		ПроверитьЗаполнениеПредопределенного(Отказ);
	КонецЕсли;
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПользователемИзмененаПометкаУдаления = (
		Не ЭтоНовый()
		И ПометкаУдаления <> Ссылка.ПометкаУдаления
		И Не ДополнительныеСвойства.Свойство("ЗаполнениеПредопределенных"));
	
	Если Не Пользовательский И ПользователемИзмененаПометкаУдаления Тогда
		Если ПометкаУдаления Тогда
			ТекстОшибки = НСтр("ru = 'Пометка на удаление предопределенного варианта отчета запрещена.'");
		Иначе
			ТекстОшибки = НСтр("ru = 'Снятие пометки удаления предопределенного варианта отчета запрещено.'");
		КонецЕсли;
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
	Если Не ПометкаУдаления И ПользователемИзмененаПометкаУдаления Тогда
		НаименованиеЗанято = ВариантыОтчетов.НаименованиеЗанято(Отчет, Ссылка, Наименование);
		КлючВариантаЗанят  = ВариантыОтчетов.КлючВариантаЗанят(Отчет, Ссылка, КлючВарианта);
		Если НаименованиеЗанято ИЛИ КлючВариантаЗанят Тогда
			ТекстОшибки = НСтр("ru = 'Ошибка снятия пометки удаления варианта отчета:'");
			Если НаименованиеЗанято Тогда
				ТекстОшибки = ТекстОшибки + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Наименование ""%1"" уже занято другим вариантом этого отчета.'"),
					Наименование);
			Иначе
				ТекстОшибки = ТекстОшибки + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Ключ варианта ""%1"" уже занят другим вариантом этого отчета.'"),
					КлючВарианта);
			КонецЕсли;
			ТекстОшибки = ТекстОшибки + НСтр("ru = 'Перед снятием пометки удаления варианта отчета
				|необходимо установить пометку удаления конфликтующего варианта отчета.'");
			ВызватьИсключение ТекстОшибки;
		КонецЕсли;
	КонецЕсли;
	
	Если ПользователемИзмененаПометкаУдаления Тогда
		ИнтерактивнаяПометкаУдаления = ?(Пользовательский, ПометкаУдаления, Ложь);
	КонецЕсли;
	
	// Удаление из табличной части подсистем, помеченных на удаление.
	УдаляемыеСтроки = Новый Массив;
	Для Каждого СтрокаРазмещения Из Размещение Цикл
		Если СтрокаРазмещения.Подсистема.ПометкаУдаления = Истина Тогда
			УдаляемыеСтроки.Добавить(СтрокаРазмещения);
		КонецЕсли;
	КонецЦикла;
	Для Каждого СтрокаРазмещения Из УдаляемыеСтроки Цикл
		Размещение.Удалить(СтрокаРазмещения);
	КонецЦикла;
	
	ЗаполнитьПоляДляПоиска();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПриЧтенииПредставленийНаСервере() Экспорт
	
	ЛокализацияСервер.ПриЧтенииПредставленийНаСервере(ЭтотОбъект);
	
КонецПроцедуры	

// Заполнение реквизитов НаименованияПолей и НаименованияПараметровИОтборов.
Процедура ЗаполнитьПоляДляПоиска()
	Дополнительный = (ТипОтчета = Перечисления.ТипыОтчетов.Дополнительный);
	Если Не Пользовательский И Не Дополнительный Тогда
		Возврат;
	КонецЕсли;
	
	Попытка
		УстановитьОтключениеБезопасногоРежима(Истина);
		УстановитьПривилегированныйРежим(Истина);
		ВариантыОтчетов.ЗаполнитьПоляДляПоиска(ЭтотОбъект);
	Исключение
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось проиндексировать схему варианта ""%1"" отчета ""%2"":'"),
			КлючВарианта, Строка(Отчет));
		ТекстОшибки = ТекстОшибки + Символы.ПС + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ВариантыОтчетов.ЗаписатьВЖурнал(УровеньЖурналаРегистрации.Ошибка, ТекстОшибки, Ссылка);
	КонецПопытки;
КонецПроцедуры

// Заполняет родителя варианта отчета, основываясь на ссылке отчета и предопределенных настройках.
Процедура ЗаполнитьРодителя() Экспорт
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	Предопределенные.Ссылка КАК ПредопределенныйВариант
	|ПОМЕСТИТЬ втПредопределенные
	|ИЗ
	|	Справочник.ПредопределенныеВариантыОтчетов КАК Предопределенные
	|ГДЕ
	|	Предопределенные.Отчет = &Отчет
	|	И Предопределенные.ПометкаУдаления = ЛОЖЬ
	|	И Предопределенные.ГруппироватьПоОтчету
	|
	|УПОРЯДОЧИТЬ ПО
	|	Предопределенные.Включен УБЫВ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	ВариантыОтчетов.Ссылка
	|ИЗ
	|	втПредопределенные КАК втПредопределенные
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ВариантыОтчетов КАК ВариантыОтчетов
	|		ПО втПредопределенные.ПредопределенныйВариант = ВариантыОтчетов.ПредопределенныйВариант
	|ГДЕ
	|	ВариантыОтчетов.ПометкаУдаления = ЛОЖЬ";
	Если ТипОтчета = Перечисления.ТипыОтчетов.Расширение Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, ".ПредопределенныеВариантыОтчетов", ".ПредопределенныеВариантыОтчетовРасширений");
	КонецЕсли;
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Отчет", Отчет);
	Запрос.Текст = ТекстЗапроса;
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Родитель = Выборка.Ссылка;
	КонецЕсли;
КонецПроцедуры

// Базовые проверки корректности данных предопределенных вариантов отчетов.
Процедура ПроверитьЗаполнениеПредопределенного(Отказ)
	Если ПометкаУдаления Или Не Предопределенный Тогда
		Возврат;
	ИначеЕсли Не ЗначениеЗаполнено(Отчет) Тогда
		ТекстОшибки = НеЗаполненоПоле("Отчет");
	ИначеЕсли Не ЗначениеЗаполнено(ТипОтчета) Тогда
		ТекстОшибки = НеЗаполненоПоле("ТипОтчета");
	ИначеЕсли ТипОтчета <> ВариантыОтчетов.ТипОтчета(Отчет) Тогда
		ТекстОшибки = НСтр("ru = 'Противоречивые значения полей ""%1"" и ""%2""'");
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки, "ТипОтчета", "Отчет");
	ИначеЕсли Не ЗначениеЗаполнено(ПредопределенныйВариант)
		И (ТипОтчета = Перечисления.ТипыОтчетов.Внутренний Или ТипОтчета = Перечисления.ТипыОтчетов.Расширение) Тогда
		ТекстОшибки = НеЗаполненоПоле("ПредопределенныйВариант");
	Иначе
		Возврат;
	КонецЕсли;
	ВызватьИсключение ТекстОшибки;
КонецПроцедуры

Функция НеЗаполненоПоле(ИмяПоля)
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Не заполнено поле ""%1""'"), ИмяПоля);
КонецФункции

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли