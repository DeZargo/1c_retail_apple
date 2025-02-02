﻿#Область ПрограммныйИнтерфейс

&НаКлиенте
Процедура ОповещениеОткрытьФормуПроизводителя(РезультатОткрытияФормы, ДополнительныеПараметры) Экспорт
	
	ЗаполнитьТекстПроизводителя();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	АдресСпискаАлкогольнойПродукции = "";
	Параметры.Свойство("АдресСпискаАлкогольнойПродукции", АдресСпискаАлкогольнойПродукции);
	
	МассивЭлементов = ПолучитьИзВременногоХранилища(АдресСпискаАлкогольнойПродукции);
	Если ТипЗнч(МассивЭлементов) <> Тип("Массив") Тогда
		ВызватьИсключение НСтр("ru = 'В форму создания номенклатуры переданы некорректные параметры.'");
	КонецЕсли;
	
	СоответствиеНоменклатуры = ПолучитьСоответствиеНоменклатуры(МассивЭлементов);
	
	Для каждого АлкогольнаяПродукция Из МассивЭлементов Цикл
	
		Если СоответствиеНоменклатуры.Получить(АлкогольнаяПродукция) = Неопределено Тогда
			СписокАлкогольнойПродукции.Добавить(АлкогольнаяПродукция);
		КонецЕсли;
	
	КонецЦикла;
	
	Если СписокАлкогольнойПродукции.Количество() = 0 Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ЗаполнитьТекстПроизводителя();
	
	Если Параметры.Свойство("УникальныйИдентификаторФормыВладелеца") Тогда
	
		УникальныйИдентификаторФормыВладелеца = Параметры.УникальныйИдентификаторФормыВладелеца;
	
	КонецЕсли;
	
	ИндивидуальныйНаборУпаковок = Справочники.НаборыУпаковок.ИндивидуальныйДляНоменклатуры;
	
	ЗаголовокКоманды = НСтр("ru = 'Создать номенклатуру (%КоличествоЭлементов%)'");
	Элементы.ФормаСоздатьНоменклатуру.Заголовок = СтрЗаменить(ЗаголовокКоманды, "%КоличествоЭлементов%", СписокАлкогольнойПродукции.Количество());
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура НаборУпаковокПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(НаборУпаковок)
		И НаборУпаковок <> ИндивидуальныйНаборУпаковок Тогда
		ЕдиницаИзмерения = ОбщегоНазначенияРТВызовСервера.ЗначениеРеквизитаОбъекта(НаборУпаковок, "ЕдиницаИзмерения");
	КонецЕсли;

	ИндивидуальныеУпаковки = НаборУпаковок = ИндивидуальныйНаборУпаковок ИЛИ НЕ ЗначениеЗаполнено(НаборУпаковок);
	
	Элементы.ЕдиницаИзмерения.ТолькоПросмотр = Не ИндивидуальныеУпаковки;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидНоменклатурыПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(ВидНоменклатуры) Тогда
		СтруктураРеквизитов = Новый Структура;
		СтруктураРеквизитов.Вставить("НаборУпаковок");
		СтруктураРеквизитов.Вставить("ЕдиницаИзмерения");
		СтруктураРеквизитов.Вставить("СтавкаНДС");
		СтруктураРеквизитов.Вставить("ТоварнаяГруппа");
		СтруктураРеквизитов.Вставить("ЦеноваяГруппа");
		СтруктураРеквизитов.Вставить("ИмпортнаяАлкогольнаяПродукция");
		
		ЗначенияРеквизитов = ОбщегоНазначенияРТВызовСервера.ПолучитьЗначенияРеквизитовОбъекта(ВидНоменклатуры, СтруктураРеквизитов);
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ЗначенияРеквизитов);
		
		Если НЕ ЗначенияРеквизитов.ИмпортнаяАлкогольнаяПродукция Тогда
			СтранаПроисхождения = ПредопределенноеЗначение("Справочник.СтраныМира.Россия");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТекстПроизводительНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПараметрыФормы = Новый Структура;
	ОбработчикОповещения = Новый ОписаниеОповещения("ОповещениеОткрытьФормуПроизводителя", ЭтотОбъект);
	Режим = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	Если НЕ ЗначениеЗаполнено(Производитель) Тогда
		ПараметрыФормы.Вставить("Отбор", Новый Структура);
		ПараметрыФормы.Отбор.Вставить("Ссылка", ПроизводительЕГАИС);
		
		ОткрытьФорму("Справочник.КлассификаторОрганизацийЕГАИС.ФормаСписка", ПараметрыФормы,,,,, ОбработчикОповещения, Режим);
	Иначе
		ПараметрыФормы.Вставить("Ключ", ПроизводительЕГАИС);
		ОткрытьФорму("Справочник.КлассификаторОрганизацийЕГАИС.ФормаОбъекта", ПараметрыФормы,,,,, ОбработчикОповещения, Режим);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьНоменклатуру(Команда)
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыСозданияНоменклатуры = Новый Структура;
	ПараметрыСозданияНоменклатуры.Вставить("Родитель"            , Родитель);
	ПараметрыСозданияНоменклатуры.Вставить("ВидНоменклатуры"     , ВидНоменклатуры);
	ПараметрыСозданияНоменклатуры.Вставить("НаборУпаковок"       , НаборУпаковок);
	ПараметрыСозданияНоменклатуры.Вставить("ЕдиницаИзмерения"    , ЕдиницаИзмерения);
	ПараметрыСозданияНоменклатуры.Вставить("СтавкаНДС"           , СтавкаНДС);
	ПараметрыСозданияНоменклатуры.Вставить("ТоварнаяГруппа"      , ТоварнаяГруппа);
	ПараметрыСозданияНоменклатуры.Вставить("ЦеноваяГруппа"       , ЦеноваяГруппа);
	ПараметрыСозданияНоменклатуры.Вставить("СтранаПроисхождения" , СтранаПроисхождения);
	ПараметрыСозданияНоменклатуры.Вставить("МассивЭлементов"     , СписокАлкогольнойПродукции.ВыгрузитьЗначения());
	
	ПараметрыСозданияНоменклатуры.Вставить("УникальныйИдентификаторФормыВладелеца"     , УникальныйИдентификаторФормыВладелеца);
	
	Закрыть(ПараметрыСозданияНоменклатуры);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПолучитьСоответствиеНоменклатуры(МассивАлкогольнойПродукции)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивАлкогольнойПродукции", МассивАлкогольнойПродукции);
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СоответствиеНоменклатурыЕГАИС.АлкогольнаяПродукция,
	|	СоответствиеНоменклатурыЕГАИС.Номенклатура
	|ИЗ
	|	РегистрСведений.СоответствиеНоменклатурыЕГАИС КАК СоответствиеНоменклатурыЕГАИС
	|ГДЕ
	|	СоответствиеНоменклатурыЕГАИС.АлкогольнаяПродукция В(&МассивАлкогольнойПродукции)";
	
	СоответствиеНоменклатуры = Новый Соответствие;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		СоответствиеНоменклатуры.Вставить(Выборка.АлкогольнаяПродукция, Выборка.Номенклатура);
	КонецЦикла;
	
	Возврат СоответствиеНоменклатуры;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьТекстПроизводителя()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("СписокАлкогольнойПродукции", СписокАлкогольнойПродукции);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КлассификаторАлкогольнойПродукцииЕГАИС.Производитель КАК Производитель
	|ИЗ
	|	Справочник.КлассификаторАлкогольнойПродукцииЕГАИС КАК КлассификаторАлкогольнойПродукцииЕГАИС
	|ГДЕ
	|	КлассификаторАлкогольнойПродукцииЕГАИС.Ссылка В(&СписокАлкогольнойПродукции)";
	
	Результат = Запрос.Выполнить();
	
	МассивПроизводителей = Новый Массив;
	МассивПроизводителей = Результат.Выгрузить().ВыгрузитьКолонку("Производитель");
	
	Если МассивПроизводителей.Количество() > 1 ИЛИ МассивПроизводителей.Количество() = 0 Тогда
		ТекстПроизводитель = "";
		Производитель = Справочники.Контрагенты.ПустаяСсылка();
	Иначе
		ПроизводительЕГАИС = МассивПроизводителей[0];
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	КлассификаторОрганизацийЕГАИС.Ссылка КАК Ссылка,
		|	КлассификаторОрганизацийЕГАИС.Контрагент КАК Контрагент,
		|	КлассификаторОрганизацийЕГАИС.Контрагент.Наименование КАК Наименование
		|ИЗ
		|	Справочник.КлассификаторОрганизацийЕГАИС КАК КлассификаторОрганизацийЕГАИС
		|ГДЕ
		|	КлассификаторОрганизацийЕГАИС.Ссылка = &Ссылка";
		
		Запрос.УстановитьПараметр("Ссылка", ПроизводительЕГАИС);
		
		Результат = Запрос.Выполнить();
		Выборка = Результат.Выбрать();
		
		Если Выборка.Следующий() Тогда
			Производитель = Выборка.Контрагент;
		Иначе
			Производитель = Справочники.Контрагенты.ПустаяСсылка();
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Производитель) Тогда
			ТекстПроизводитель = НСтр("ru = 'Производитель: '") + Выборка.Наименование
		Иначе
			ТекстПроизводитель = НСтр("ru = 'Ввести соответствие для производителя'");
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
