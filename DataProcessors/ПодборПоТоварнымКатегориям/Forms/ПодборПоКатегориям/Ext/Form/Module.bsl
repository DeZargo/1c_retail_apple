﻿
#Область ПрограммныйИнтерфейс

#Область ОбработчикиСобытийПодключаемогоОборудования

&НаКлиенте
Процедура ОповещениеПоискаПоШтрихкоду(Штрихкод, ДополнительныеПараметры) Экспорт
	
	Если НЕ ПустаяСтрока(Штрихкод) Тогда
		СтруктураПараметровКлиента = ПолученШтрихкодИзСШК(Штрихкод);
		ОбработатьДанныеПоКодуКлиент(СтруктураПараметровКлиента);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОповещениеПоискаПоМагнитномуКоду(ТекКод, ДополнительныеПараметры) Экспорт
	
	Если Не ПустаяСтрока(ТекКод) Тогда
		СтруктураПараметровКлиента = ПолученМагнитныйКод(ТекКод);
		ОбработатьДанныеПоКодуКлиент(СтруктураПараметровКлиента);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОповещениеОткрытьФормуВыбораДанныхПоиска(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		ОбработатьДанныеПоКодуСервер(Результат);
		ОбработатьДанныеПоКодуКлиент(Результат)
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолученМагнитныйКод(МагнитныйКод) Экспорт 
	
	СтруктураРезультат = ПодключаемоеОборудованиеРТВызовСервера.ПолученМагнитныйКод(МагнитныйКод, ЭтотОбъект);
	Возврат СтруктураРезультат;
	
КонецФункции

&НаСервере
Функция ПолученШтрихкодИзСШК(Штрихкод) Экспорт
	
	СтруктураРезультат = ПодключаемоеОборудованиеРТВызовСервера.ПолученШтрихкодИзСШК(Штрихкод, ЭтотОбъект);
	Возврат СтруктураРезультат;
	
КонецФункции

&НаСервере
Процедура ОбработатьДанныеПоКодуСервер(СтруктураРезультат) Экспорт
	
	СтрокаРезультата = СтруктураРезультат.ЗначенияПоиска[0];
	
	Если СтрокаРезультата.Свойство("Карта") Тогда
		
		ПодключаемоеОборудованиеРТВызовСервера.ВставитьПредупреждениеОНевозможностиОбработкиКарт(СтруктураРезультат, СтрокаРезультата);
		
	Иначе
		
		СтруктураСтроки = Новый Структура;
		СтруктураСтроки.Вставить("Номенклатура", СтрокаРезультата.Номенклатура);
		СтрокаКатегории = Неопределено;
		КатегорияПоиска = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтрокаРезультата.Номенклатура, "ТоварнаяКатегория");
		Если НЕ ЗначениеЗаполнено(КатегорияПоиска) Тогда
			КатегорияПоиска = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтрокаРезультата.Номенклатура, "ВидНоменклатуры");
		КонецЕсли;
		ЭлементыДерева = ДеревоКатегорий.ПолучитьЭлементы();
		Для Каждого ЭлементКатегории Из ЭлементыДерева Цикл
			Если ЭлементКатегории.ВидКатегорияМарка = КатегорияПоиска  Тогда
				СтрокаКатегории = ЭлементКатегории.ПолучитьИдентификатор();
				Прервать;
			КонецЕсли;
		КонецЦикла;
		СтруктураСтроки.Вставить("СтрокаКатегории", СтрокаКатегории);
		СтруктураРезультат.Вставить("АктивизироватьСтроку", СтруктураСтроки);
		
	КонецЕсли;
	
	Если СтрокаРезультата.Свойство("ТекстПредупреждения") Тогда
		СтруктураРезультат.Вставить("ТекстПредупреждения", СтрокаРезультата.ТекстПредупреждения);
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьДанныеПоКодуКлиент(СтруктураПараметровКлиента) Экспорт
	
	ОткрытаБлокирующаяФорма = Ложь;
	
	ПодключаемоеОборудованиеРТКлиент.ОбработатьДанныеПоКоду(ЭтотОбъект, СтруктураПараметровКлиента, ОткрытаБлокирующаяФорма);
	
	Если НЕ ОткрытаБлокирующаяФорма Тогда
		ЗавершитьОбработкуДанныхПоКодуКлиент(СтруктураПараметровКлиента);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

// Процедура обработчик ответа на вопрос
// о подтверждении закрытия формы
// вызывается в результате немодального вопроса ПередЗакрытием формы.
&НаКлиенте
Процедура ОбработкаПодтвержденияЗакрытияФормы(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ПеренестиВДокумент();
	ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда
		ЗакрытиеПодтверждено = Истина;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

// Процедура обработчик ответа на вопрос
// о добавлении товара в таблицу подобранных товаров
// вызывается в результате немодального вопроса из обработчика ТаблицаТоваровВыбор
// а также принудительно из этого же обработчика, если вопрос не использовался.
&НаКлиенте
Процедура ТаблицаТоваровВыборЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Если ДополнительныеПараметры.ПроверятьКвоту Тогда
			ПроверитьКвотуПередДобавлением(ДополнительныеПараметры);
		Иначе
			СтрокаТаблицы = ДополнительныеПараметры.СтрокаТаблицы;
			
			НоваяСтрока = ТаблицаВыбранныхТоваров.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТаблицы);
			ОбновитьНаполнениеСУчетомПодбораВДереве(НоваяСтрока.ПолучитьИдентификатор(), 1);
			ЭтаФорма.Модифицированность = Истина;
			//
			ТаблицаВыбранныхТоваровПриИзменении();
			Если НЕ ПоказыватьПодобранныеТовары Тогда
				
				ТекстСобытия = НСтр("ru = 'Товар добавлен в таблицу подбора'");
				ТекстОповещения = НСтр("ru = 'Товар %1 добавлен в таблицу подбора'");
				ТекстОповещения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
									ТекстОповещения,
									СтрокаТаблицы.Номенклатура);
				ПоказатьОповещениеПользователя(ТекстСобытия, , ТекстОповещения);
				
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// ПодключаемоеОборудование
	ПодключаемоеОборудованиеРТВызовСервера.НастроитьПодключаемоеОборудование(ЭтотОбъект);
	// Конец ПодключаемоеОборудование
	
	ДополнительныеКолонкиНоменклатуры = ЗначениеНастроекПовтИсп.ПолучитьЗначениеКонстанты("ДополнительнаяКолонкаПриОтображенииНоменклатуры");
	
	ОбъектПланирования = Параметры.ОбъектПланирования;
	Операция = Параметры.Операция;
	Стадия = Параметры.Стадия;
	ДатаНачалаДействия = Параметры.ДатаНачалаДействия;
	
	ОтборыСписковКлиентСервер.УстановитьПараметрДинамическогоСписка(
		ТаблицаТоваров,
		"НаДату",
		ДатаНачалаДействия,
		Истина);
	ОтборыСписковКлиентСервер.УстановитьПараметрДинамическогоСписка(
		ТаблицаТоваров,
		"ОбъектПланирования",
		ОбъектПланирования,
		Истина);
	ОтборыСписковКлиентСервер.УстановитьПараметрДинамическогоСписка(
		ТаблицаТоваров,
		"ПрочиеМарки",
		НСтр("ru = 'Прочие марки'"),
		Истина);
	
	Если Параметры.ФормироватьДеревоПриОткрытии Тогда
		СформироватьДеревоКатегорийСервер();
	КонецЕсли;
	
	Элементы.ТаблицаВыбранныхТоваров.Видимость = ПоказыватьПодобранныеТовары;
	ИспользоватьТоварныеКатегорииИКвотыАссортимента = ПолучитьФункциональнуюОпцию("ИспользоватьТоварныеКатегорииИКвотыАссортимента");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьИнформационнуюНадписьКоличестваТоваров();
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтотОбъект, "СканерШтрихкода, СчитывательМагнитныхКарт");
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если НЕ ПеренестиВДокумент И ТаблицаВыбранныхТоваров.Количество() > 0 Тогда
		Если НЕ ЗакрытиеПодтверждено Тогда
			
			Если ЗавершениеРаботы Тогда
				Отказ = Истина;
				Возврат;
			КонецЕсли;
			
			ДополнительныеПараметры = Новый Структура;
			ОбработчикОповещения = Новый ОписаниеОповещения(
											"ОбработкаПодтвержденияЗакрытияФормы",
											ЭтотОбъект,
											ДополнительныеПараметры);
			ТекстВопроса = НСтр("ru='Перенести выбранные позиции в документ?'");
			ПоказатьВопрос(ОбработчикОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);
			Отказ = Истина;
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтотОбъект);
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаКлиенте
Процедура ВнешнееСобытие(Источник, Событие, Данные)
	
	Если ВводДоступен() Тогда
		ПодключаемоеОборудованиеРТКлиент.ВнешнееСобытиеОборудования(ЭтотОбъект, Источник, Событие, Данные);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ПоказыватьПодобранныеТовары = Настройки.Получить("ПоказыватьПодобранныеТовары");
	
	Элементы.ТаблицаВыбранныхТоваров.Видимость = ПоказыватьПодобранныеТовары;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПоказыватьПодобранныеТоварыПриИзменении(Элемент)
	Элементы.ТаблицаВыбранныхТоваров.Видимость=ПоказыватьПодобранныеТовары;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоКатегорий

&НаКлиенте
Процедура ДеревоКатегорийПриАктивизацииСтроки(Элемент)
	ПодключитьОбработчикОжидания("УстановитьОтборПоТекущейСтрокеДереваОбработчикОжидания", 0.2, Истина);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТаблицаТоваров

&НаКлиенте
Процедура ТаблицаТоваровВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	СтрокаТаблицы = Элемент.ТекущиеДанные;
	
	Если СтрокаТаблицы <> Неопределено Тогда
		
		УжеВыбрано = Ложь;
		СтруктураПоиска = Новый Структура("Номенклатура", СтрокаТаблицы.Номенклатура);
		МассивНайденных = ТаблицаВыбранныхТоваров.НайтиСтроки(СтруктураПоиска);
		Если МассивНайденных.Количество()>0 Тогда
			УжеВыбрано = Истина;
		КонецЕсли;
		
		Если УжеВыбрано Тогда
			
			ТекстСобытия = НСтр("ru = 'Товар уже присутствует в таблице подбора'");
			ТекстОповещения = НСтр("ru = 'Товар %1 уже присутствует в таблице подбора'");
			ТекстОповещения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
								ТекстОповещения,
								СтрокаТаблицы.Номенклатура);
			
			ПоказатьОповещениеПользователя(ТекстСобытия, , ТекстОповещения);
			
		Иначе
			ДополнительныеПараметры = Новый Структура;
			ДополнительныеПараметры.Вставить("СтрокаТаблицы", СтрокаТаблицы);
			ДополнительныеПараметры.Вставить("ПроверятьКвоту", Ложь);
			
			ТекстВопроса = "";
			
			Если Операция = ПредопределенноеЗначение("Перечисление.ОперацииИзмененияАссортимента.ВыводИзАссортимента")
				ИЛИ Операция = ПредопределенноеЗначение("Перечисление.ОперацииИзмененияАссортимента.ПереносВАрхивОтзыв") Тогда
				
				Если (СтрокаТаблицы.СтадияАссортимента = Стадия
					ИЛИ НЕ ЗначениеЗаполнено(СтрокаТаблицы.СтадияАссортимента)) Тогда
					
					ТекстВопроса = НСтр("ru = 'Данный товар уже выведен из ассортимента.'") + Символы.ПС
									+ НСтр("ru = 'Добавление его в документ не требуется.'") + Символы.ПС
									+ НСтр("ru = 'Продолжить?'");
									
				КонецЕсли;
			Иначе
				ДополнительныеПараметры.ПроверятьКвоту = ИспользоватьТоварныеКатегорииИКвотыАссортимента;
				Если СтрокаТаблицы.СтадияАссортимента = Стадия
					И НЕ Операция
					= ПредопределенноеЗначение("Перечисление.ОперацииИзмененияАссортимента.ИзменениеСостоянияАссортимента") Тогда
					
					ТекстВопроса = НСтр("ru = 'Данный товар уже находится в стадии %1.'") + Символы.ПС
									+ НСтр("ru = 'Добавление его в документ не требуется.'") + Символы.ПС
									+ НСтр("ru = 'Продолжить?'");
					ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
									ТекстВопроса,
									СтрокаТаблицы.СтадияАссортимента);
				КонецЕсли;
			КонецЕсли;
			Если ПустаяСтрока(ТекстВопроса) Тогда
				ТаблицаТоваровВыборЗавершение(КодВозвратаДиалога.Да, ДополнительныеПараметры);
			Иначе
				ОбработчикОповещения = Новый ОписаниеОповещения(
												"ТаблицаТоваровВыборЗавершение",
												ЭтотОбъект,
												ДополнительныеПараметры);
				ПоказатьВопрос(ОбработчикОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
			КонецЕсли;
		КонецЕсли;
			
	КонецЕсли;
						
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТаблицаВыбранныхТоваров

&НаКлиенте
Процедура ТаблицаВыбранныхТоваровПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаВыбранныхТоваровПередУдалением(Элемент, Отказ)
	
	ТекущаяУдаляемаяСтрока = Элементы.ТаблицаВыбранныхТоваров.ТекущиеДанные;
	Если ТекущаяУдаляемаяСтрока <> Неопределено Тогда
		ОбновитьНаполнениеСУчетомПодбораВДереве(ТекущаяУдаляемаяСтрока.ПолучитьИдентификатор(), -1);
		Элементы.ДеревоКатегорий.ТекущаяСтрока = 2;
		ОбновитьИнформационнуюНадписьКоличестваТоваров();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

#Область ОбработчикиКомандПодключаемогоОборудования

&НаКлиенте
Процедура ПоискПоМагнитномуКоду(Команда)
	
	ОбработкаТабличнойЧастиТоварыКлиент.ВвестиМагнитныйКод(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоискПоШтрихкоду(Команда)
	
	ОбработкаТабличнойЧастиТоварыКлиент.ВвестиШтрихкод(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура ПеренестиВДокумент(Команда = Неопределено)
	ПеренестиВДокумент = Истина;
	ЗакрытиеПодтверждено = Истина;
	
	Если ПеренестиВДокумент Тогда
		СтруктураАдресов = ПоместитьТоварыВХранилище();
		ОповеститьОВыборе(СтруктураАдресов);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ТаблицаВыбранныхТоваровПриИзменении()
	
	ОбновитьИнформационнуюНадписьКоличестваТоваров();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборПоТекущейСтрокеДереваОбработчикОжидания()
	ТекущаяСтрокаДерева=Элементы.ДеревоКатегорий.ТекущиеДанные;
	
	ТаблицаТоваров.КомпоновщикНастроек.Настройки.Отбор.Элементы.Очистить();
	
	Если ТекущаяСтрокаДерева=Неопределено Тогда
	Иначе
		Если ТипЗнч(ТекущаяСтрокаДерева.ВидКатегорияМарка)=Тип("СправочникСсылка.ВидыНоменклатуры") Тогда
			Если ТекущаяСтрокаДерева.ЭтоГруппаВидов Тогда
				ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(
					ТаблицаТоваров,
					"ОтборВидНоменклатуры",
					ТекущаяСтрокаДерева.ВидКатегорияМарка,
					Истина,
					ВидСравненияКомпоновкиДанных.ВИерархии);
			Иначе
				ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(
					ТаблицаТоваров,
					"ОтборВидНоменклатуры",
					ТекущаяСтрокаДерева.ВидКатегорияМарка,
					Истина,
					ВидСравненияКомпоновкиДанных.Равно);
			КонецЕсли;
		ИначеЕсли ТипЗнч(ТекущаяСтрокаДерева.ВидКатегорияМарка)=Тип("СправочникСсылка.ТоварныеКатегории") Тогда
			Если ТекущаяСтрокаДерева.ЭтоГруппаКатегорий Тогда
				ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(
					ТаблицаТоваров,
					"ОтборТоварнаяКатегория",
					ТекущаяСтрокаДерева.ВидКатегорияМарка,
					Истина,
					ВидСравненияКомпоновкиДанных.ВИерархии);
			Иначе
				ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(
					ТаблицаТоваров,
					"ОтборТоварнаяКатегория",
					ТекущаяСтрокаДерева.ВидКатегорияМарка,
					Истина,
					ВидСравненияКомпоновкиДанных.Равно);
			КонецЕсли;
		ИначеЕсли ТипЗнч(ТекущаяСтрокаДерева.ВидКатегорияМарка)=Тип("СправочникСсылка.Марки")
			ИЛИ ТипЗнч(ТекущаяСтрокаДерева.ВидКатегорияМарка)=Тип("Строка") Тогда
			РодительСтрокиДерева=ТекущаяСтрокаДерева.ПолучитьРодителя();
			Если РодительСтрокиДерева<>Неопределено Тогда
				ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(
					ТаблицаТоваров,
					"ОтборТоварнаяКатегория",
					РодительСтрокиДерева.ВидКатегорияМарка,
					Истина,
					ВидСравненияКомпоновкиДанных.Равно);
			КонецЕсли;
			ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(
				ТаблицаТоваров,
				"ОтборМарка",
				ТекущаяСтрокаДерева.ВидКатегорияМарка,
				Истина,
				ВидСравненияКомпоновкиДанных.Равно);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура СформироватьДеревоКатегорийСервер()
	Запрос = Новый Запрос("ВЫБРАТЬ
	|	Квоты.ТоварнаяКатегория КАК ТоварнаяКатегория,
	|	Квоты.Марка КАК Марка,
	|	Квоты.Квота КАК Квота,
	|	Квоты.ПроцентОтклонения КАК ПроцентОтклонения
	|ПОМЕСТИТЬ втПланКатегории
	|ИЗ
	|	РегистрСведений.КвотыАссортимента.СрезПоследних(&НаДату, ОбъектПланирования = &ОбъектПланирования) КАК Квоты
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ФорматыМагазинов КАК Форматы
	|		ПО Квоты.ОбъектПланирования = Форматы.Ссылка
	|			И (Квоты.Период В
	|				(ВЫБРАТЬ
	|					МАКСИМУМ(К.Период)
	|				ИЗ
	|					РегистрСведений.КвотыАссортимента КАК К
	|				ГДЕ
	|					К.Период <= &НаДату
	|					И К.ОбъектПланирования = &ОбъектПланирования))
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СправочникНоменклатура.Ссылка КАК Номенклатура,
	|	СправочникНоменклатура.ТоварнаяКатегория КАК ТоварнаяКатегория,
	|	СправочникНоменклатура.ВидНоменклатуры КАК ВидНоменклатуры,
	|	ЕСТЬNULL(ПланКатегории.Марка, ЗНАЧЕНИЕ(Справочник.Марки.ПустаяСсылка)) КАК Марка,
	|	ЕСТЬNULL(ПланКатегории.Квота, 0) КАК Квота,
	|	Ассортимент.Номенклатура КАК НоменклатураНаполнения,
	|	ЕСТЬNULL(Ассортимент.РольАссортимента, ЗНАЧЕНИЕ(Перечисление.РолиАссортимента.ПустаяСсылка)) КАК РольАссортимента,
	|	ЕСТЬNULL(Ассортимент.РазрешеныЗакупки, ЛОЖЬ) КАК РазрешеныЗакупки,
	|	ЕСТЬNULL(Ассортимент.РазрешеныПродажи, ЛОЖЬ) КАК РазрешеныПродажи,
	|	Ассортимент.ВидЦен КАК ВидЦен
	|ПОМЕСТИТЬ втТекущийАссортимент
	|ИЗ
	|	Справочник.Номенклатура КАК СправочникНоменклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.Ассортимент.СрезПоследних(
	|							КОНЕЦПЕРИОДА(&НаДату, ДЕНЬ),
	|								ОбъектПланирования = &ОбъектПланирования) КАК Ассортимент
	|		ПО (Ассортимент.Номенклатура = СправочникНоменклатура.Ссылка)
	|			И (Ассортимент.РазрешеныЗакупки)
	|		ЛЕВОЕ СОЕДИНЕНИЕ втПланКатегории КАК ПланКатегории
	|		ПО (ПланКатегории.ТоварнаяКатегория = СправочникНоменклатура.ТоварнаяКатегория)
	|			И (ПланКатегории.Марка = СправочникНоменклатура.Марка)
	|ГДЕ
	|	НЕ СправочникНоменклатура.ЭтоГруппа
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТекущийАссортимент.ВидНоменклатуры,
	|	ТекущийАссортимент.ТоварнаяКатегория,
	|	ТекущийАссортимент.Марка,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ТекущийАссортимент.Номенклатура) КАК ВсегоНоменклатурыВКатегории,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ТекущийАссортимент.НоменклатураНаполнения) КАК НаполнениеКатегории
	|ПОМЕСТИТЬ втИтогиПоКатегориям
	|ИЗ
	|	втТекущийАссортимент КАК ТекущийАссортимент
	|
	|СГРУППИРОВАТЬ ПО
	|	ТекущийАссортимент.ВидНоменклатуры,
	|	ТекущийАссортимент.ТоварнаяКатегория,
	|	ТекущийАссортимент.Марка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	тКатегории.ВидНоменклатуры КАК ВидНоменклатуры,
	|	тКатегории.ВидНоменклатуры.Наименование КАК НаименованиеВидаНоменклатуры,
	|	тКатегории.ВидНоменклатуры.ЭтоГруппа КАК ЭтоГруппаВидов,
	|	тКатегории.ТоварнаяКатегория КАК ТоварнаяКатегория,
	|	ЕСТЬNULL(тКатегории.ТоварнаяКатегория.Наименование, &ПустаяКатегория) КАК НаименованиеКатегории,
	|	ЕСТЬNULL(тКатегории.ТоварнаяКатегория.ЭтоГруппа, ЛОЖЬ) КАК ЭтоГруппаКатегорий,
	|	тКатегории.Марка КАК Марка,
	|	тКатегории.НаименованиеМарки КАК НаименованиеМарки,
	|	тКатегории.Квота КАК Квота,
	|	тКатегории.ПроцентОтклонения КАК ПроцентОтклонения,
	|	ИтогиПоКатегориям.ВсегоНоменклатурыВКатегории КАК ВсегоНоменклатуры,
	|	ИтогиПоКатегориям.НаполнениеКатегории КАК Наполнение
	|ИЗ
	|	(ВЫБРАТЬ
	|		СправочникВиды.Ссылка КАК ВидНоменклатуры,
	|		ЕСТЬNULL(СправочникКатегории.Ссылка, ЗНАЧЕНИЕ(Справочник.ТоварныеКатегории.ПустаяСсылка)) КАК ТоварнаяКатегория,
	|		ЕСТЬNULL(ПланКатегории.Марка, ЗНАЧЕНИЕ(Справочник.Марки.ПустаяСсылка)) КАК Марка,
	|		ЕСТЬNULL(ПланКатегории.Марка.Наименование, &ПрочиеМарки) КАК НаименованиеМарки,
	|		ЕСТЬNULL(ПланКатегории.Квота, 0) КАК Квота,
	|		ЕСТЬNULL(ПланКатегории.ПроцентОтклонения, 0) КАК ПроцентОтклонения
	|	ИЗ
	|		Справочник.ВидыНоменклатуры КАК СправочникВиды
	|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ТоварныеКатегории КАК СправочникКатегории
	|			ПО СправочникВиды.Ссылка = СправочникКатегории.Владелец
	|				И (НЕ СправочникКатегории.ЭтоГруппа)
	|			ЛЕВОЕ СОЕДИНЕНИЕ втПланКатегории КАК ПланКатегории
	|			ПО (СправочникКатегории.Ссылка = ПланКатегории.ТоварнаяКатегория)
	|	ГДЕ
	|		НЕ СправочникВиды.ЭтоГруппа) КАК тКатегории
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ втИтогиПоКатегориям КАК ИтогиПоКатегориям
	|		ПО тКатегории.ТоварнаяКатегория = ИтогиПоКатегориям.ТоварнаяКатегория
	|			И тКатегории.ВидНоменклатуры = ИтогиПоКатегориям.ВидНоменклатуры
	|			И тКатегории.Марка = ИтогиПоКатегориям.Марка
	|
	|УПОРЯДОЧИТЬ ПО
	|	НаименованиеВидаНоменклатуры,
	|	НаименованиеКатегории,
	|	НаименованиеМарки
	|ИТОГИ
	|	МАКСИМУМ(НаименованиеМарки),
	|	СУММА(Квота),
	|	0 КАК ПроцентОтклонения,
	|	СУММА(ВсегоНоменклатуры),
	|	СУММА(Наполнение)
	|ПО
	|	ВидНоменклатуры ИЕРАРХИЯ,
	|	ТоварнаяКатегория ИЕРАРХИЯ");
	Запрос.УстановитьПараметр("ОбъектПланирования", ОбъектПланирования);
	Запрос.УстановитьПараметр("НаДату", ДатаНачалаДействия);
	Запрос.УстановитьПараметр("ПустаяКатегория", НСтр("ru = '<Категория не указана>'"));
	Запрос.УстановитьПараметр("ПрочиеМарки", НСтр("ru = 'Прочие марки'"));
	//
	РезультатЗапроса=Запрос.Выполнить();
	ЗаполнитьДеревоПоРезультатуЗапроса(РезультатЗапроса);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДеревоПоРезультатуЗапроса(РезультатЗапроса)
	
	ДеревоОбъект = РеквизитФормыВЗначение("ДеревоКатегорий", Тип("ДеревоЗначений"));
	ДеревоОбъект.Строки.Очистить();
	
	ДеревоРезультат = РезультатЗапроса.Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	ЗаполнитьПодчиненныеСтроки(ДеревоОбъект, ДеревоРезультат);
	ЗначениеВРеквизитФормы(ДеревоОбъект, "ДеревоКатегорий");
	Элементы.ДеревоКатегорий.НачальноеОтображениеДерева = НачальноеОтображениеДерева.РаскрыватьВерхнийУровень;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПодчиненныеСтроки(тПриемник, тИсточник)
	
	Для Каждого СтрокаИсточника Из тИсточник.Строки Цикл
		НужноДобавлять = Ложь;
		ВидКатегорияМарка = Неопределено;
		ЭтоИтог = Ложь;
		ИндексКартинки = 0;
		Наполнение = 0;
		ВсегоНоменклатуры = 0;
		
		ЭтоГруппаКатегорий = Истина;
		Если СтрокаИсточника.Марка <> Null Тогда
			Если ЗначениеЗаполнено(СтрокаИсточника.Марка) Тогда
				НужноДобавлять = Истина;
				ВидКатегорияМарка = СтрокаИсточника.Марка;
				ЭтоИтог = Ложь;
				ИндексКартинки = 2;
				Наполнение = СтрокаИсточника.Наполнение;
				ВсегоНоменклатуры = СтрокаИсточника.ВсегоНоменклатуры;
			КонецЕсли;
		ИначеЕсли СтрокаИсточника.ТоварнаяКатегория <> Null Тогда
			Если ЗначениеЗаполнено(СтрокаИсточника.ТоварнаяКатегория) Тогда
				НужноДобавлять = Истина;
				ВидКатегорияМарка = СтрокаИсточника.ТоварнаяКатегория;
				ЭтоИтог = Истина;
				Если СтрокаИсточника.ЭтоГруппаКатегорий = Истина ИЛИ СтрокаИсточника.ЭтоГруппаКатегорий = Null Тогда
					ИндексКартинки = 0;
				Иначе
					ИндексКартинки = 1;
					ЭтоГруппаКатегорий = Ложь;
				КонецЕсли;
				Наполнение = СтрокаИсточника.Наполнение;
				ВсегоНоменклатуры = СтрокаИсточника.ВсегоНоменклатуры;
			КонецЕсли;
		Иначе
			НужноДобавлять = Истина;
			ВидКатегорияМарка = СтрокаИсточника.ВидНоменклатуры;
			ЭтоИтог = Истина;
			ИндексКартинки = 0;
			Наполнение = СтрокаИсточника.Наполнение;
			ВсегоНоменклатуры = СтрокаИсточника.ВсегоНоменклатуры;
		КонецЕсли;
		
		Если НужноДобавлять Тогда
			СтрокаПриемника = тПриемник.Строки.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаПриемника, СтрокаИсточника);
			СтрокаПриемника.ЭтоГруппаКатегорий = ЭтоГруппаКатегорий;
			СтрокаПриемника.Наполнение = Наполнение;
			СтрокаПриемника.ВсегоНоменклатуры = ВсегоНоменклатуры;
			СтрокаПриемника.НаполнениеСУчетомПодбора = Наполнение;
			СтрокаПриемника.ВидКатегорияМарка = ВидКатегорияМарка;
			СтрокаПриемника.ЭтоИтог = ЭтоИтог;
			СтрокаПриемника.ИндексКартинки = ИндексКартинки;
			// И рекурсивно подчиненные
			ЗаполнитьПодчиненныеСтроки(СтрокаПриемника, СтрокаИсточника);
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

&НаСервере
Функция ПоместитьТоварыВХранилище()
	
	втТаблицаТовары = ТаблицаВыбранныхТоваров.Выгрузить();
	
	АдресТоваровВХранилище = ПоместитьВоВременноеХранилище(втТаблицаТовары, УникальныйИдентификатор);
	СтруктураАдресов = Новый Структура;
	СтруктураАдресов.Вставить("АдресТоваровВХранилище", АдресТоваровВХранилище);
	
	Возврат СтруктураАдресов;
	
КонецФункции

&НаКлиенте
Процедура ОбновитьИнформационнуюНадписьКоличестваТоваров()
	
	ПозицииПрописью = НРег(ЧислоПрописью(ТаблицаВыбранныхТоваров.Количество(),
											"Л = ru_RU; ДП = Ложь; НП = Истина; НД = Ложь;",
											НСтр("ru = 'позиция,позиции,позиций,ж,,,,,0'")));
	ИнформационнаяНадпись = НСтр("ru = 'Всего подобрано %Позиций%.'");
	ИнформационнаяНадпись = СтрЗаменить(ИнформационнаяНадпись,"%Позиций%", ПозицииПрописью);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьНаполнениеСУчетомПодбораВДереве(ИдентификаторСтрокиПодобранныхТоваров, Количество)
	СтрокаПодобранныхТоваров = ТаблицаВыбранныхТоваров.НайтиПоИдентификатору(ИдентификаторСтрокиПодобранныхТоваров);
	Если СтрокаПодобранныхТоваров <> Неопределено Тогда
		Обновлять = Ложь;
		Если (СтрокаПодобранныхТоваров.СтадияАссортимента <> Перечисления.СтадииАссортимента.РазрешеныЗакупкиИПродажи 
			И СтрокаПодобранныхТоваров.СтадияАссортимента <> Перечисления.СтадииАссортимента.РазрешеныТолькоЗакупки)
			И (Операция <> Перечисления.ОперацииИзмененияАссортимента.ВыводИзАссортимента
				И Операция <> Перечисления.ОперацииИзмененияАссортимента.ПереносВАрхивОтзыв) Тогда
			// Если товар был запрещен к закупке - т.е. отсутствовал в ассортименте,
			// и операция не вывода из ассортимента
			// то в результате наполненность поменяется в большую сторону.
			Обновлять = Истина;
		ИначеЕсли (СтрокаПодобранныхТоваров.СтадияАссортимента = Перечисления.СтадииАссортимента.РазрешеныЗакупкиИПродажи 
			ИЛИ СтрокаПодобранныхТоваров.СтадияАссортимента = Перечисления.СтадииАссортимента.РазрешеныТолькоЗакупки)
			И (Операция = Перечисления.ОперацииИзмененияАссортимента.ВыводИзАссортимента
				ИЛИ Операция = Перечисления.ОперацииИзмененияАссортимента.ПереносВАрхивОтзыв) Тогда
			// Если товар был разрешен к закупке - т.е. присутствовал в ассортименте,
			// и операция вывода из ассортимента
			// то в результате наполненность поменяется в меньшую сторону => меняем знак.
			Обновлять = Истина;
			Количество = - Количество;
		КонецЕсли;
		Если Обновлять Тогда
			СтрокаДерева = НайтиСтрокуВДеревеКоллекции(ДеревоКатегорий, СтрокаПодобранныхТоваров.ТоварнаяКатегория);
			Если СтрокаДерева <> Неопределено Тогда
				СтрокаДерева.НаполнениеСУчетомПодбора = СтрокаДерева.НаполнениеСУчетомПодбора + Количество;
				СтрокаДереваСтроки = СтрокаДерева.ПолучитьЭлементы();
				Для Каждого ПодчиненнаяСтрока Из СтрокаДереваСтроки  Цикл
					Если ПодчиненнаяСтрока.ВидКатегорияМарка = СтрокаПодобранныхТоваров.Марка
						ИЛИ (ПодчиненнаяСтрока.ВидКатегорияМарка = НСтр("ru = 'Прочие марки'")
							И НЕ ЗначениеЗаполнено(СтрокаПодобранныхТоваров.Марка)) Тогда
						ПодчиненнаяСтрока.НаполнениеСУчетомПодбора = ПодчиненнаяСтрока.НаполнениеСУчетомПодбора + Количество;
						Прервать;
					КонецЕсли;
				КонецЦикла;
				ОбновитьНаполнениеСУчетомПодбораРодителейСтроки(СтрокаДерева, Количество);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ОбновитьНаполнениеСУчетомПодбораРодителейСтроки(СтрокаДерева, Количество)
	ТекущаяСтрокаРодитель = СтрокаДерева.ПолучитьРодителя();
	Если ТекущаяСтрокаРодитель <> Неопределено Тогда
		ТекущаяСтрокаРодитель.НаполнениеСУчетомПодбора = ТекущаяСтрокаРодитель.НаполнениеСУчетомПодбора + Количество;
		ОбновитьНаполнениеСУчетомПодбораРодителейСтроки(ТекущаяСтрокаРодитель, Количество);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция НайтиСтрокуВДеревеКоллекции(ДеревоКоллекция, ТоварнаяКатегория)
	НайденнаяСтрока = Неопределено;
	ЭлементыКоллекции = ДеревоКоллекция.ПолучитьЭлементы();
	Для Каждого ЭлементКоллекции Из ЭлементыКоллекции Цикл
		Если ЭлементКоллекции.ВидКатегорияМарка = ТоварнаяКатегория Тогда
			НайденнаяСтрока = ЭлементКоллекции;
			Прервать;
		Иначе
			ЭлементКоллекцииВПодчиненных = НайтиСтрокуВДеревеКоллекции(ЭлементКоллекции, ТоварнаяКатегория);
			Если ЭлементКоллекцииВПодчиненных <> Неопределено Тогда
				НайденнаяСтрока = ЭлементКоллекцииВПодчиненных;
				Прервать;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	Возврат НайденнаяСтрока;
КонецФункции

&НаСервере
Функция КвотаКатегории(ОбъектПланирования, ТоварнаяКатегория, МаркаОтбора, ДатаНачалаДействия)
	
	СтруктураКвоты = АссортиментСервер.СтруктураКвотыПоКатегории(ОбъектПланирования,
														 		ТоварнаяКатегория,
														 		МаркаОтбора,
														 		ДатаНачалаДействия);
	Возврат СтруктураКвоты.Квота;
	
КонецФункции

&НаКлиенте
Процедура ПроверитьКвотуПередДобавлением(ДополнительныеПараметры)
	
	ДополнительныеПараметры.ПроверятьКвоту = Ложь;
	СтрокаТаблицы = ДополнительныеПараметры.СтрокаТаблицы;
	
	МаркаОтбора = ?(СтрокаТаблицы.Марка = НСтр("ru = 'Прочие марки'"),
						ПредопределенноеЗначение("Справочник.Марки.ПустаяСсылка"),
						СтрокаТаблицы.Марка);
	
	Квота = КвотаКатегории(ОбъектПланирования,
							СтрокаТаблицы.ТоварнаяКатегория,
							МаркаОтбора,
							ДатаНачалаДействия);
	
	Если Квота = 0 Тогда // и еще вопрос...
		ОбработчикОповещения = Новый ОписаниеОповещения("ТаблицаТоваровВыборЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		
		СтрокаМарка = "";
		Если ЗначениеЗаполнено(МаркаОтбора) Тогда
			СтрокаМарка = "" + Символы.ПС + НСтр("ru = 'и марке %1'") + Символы.ПС;
			СтрокаМарка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаМарка, МаркаОтбора);
		КонецЕсли;
		ТекстВопроса = НСтр("ru = 'По товарной категории %1 %2не установлена квота.'") + Символы.ПС
			+ НСтр("ru = 'Присутствие данного товара в ассортименте'") + Символы.ПС
			+ НСтр("ru = 'противоречит ассортиментной политике.'") + Символы.ПС
			+ НСтр("ru = 'Продолжить?'");
		ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						ТекстВопроса,
						СтрокаТаблицы.ТоварнаяКатегория,
						СтрокаМарка);
		
		ПоказатьВопрос(ОбработчикОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	Иначе
		
		ТаблицаТоваровВыборЗавершение(КодВозвратаДиалога.Да, ДополнительныеПараметры);
		
	КонецЕсли;
			
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьОбработкуДанныхПоКодуКлиент(СтруктураПараметров)
	
	Если СтруктураПараметров.Свойство("АктивизироватьСтроку") Тогда
		
		СтруктураСтроки = СтруктураПараметров.АктивизироватьСтроку;
		Если СтруктураСтроки.СтрокаКатегории <> Неопределено Тогда
			Элементы.ДеревоКатегорий.ТекущаяСтрока = СтруктураСтроки.СтрокаКатегории;
			УстановитьОтборПоТекущейСтрокеДереваОбработчикОжидания();
		КонецЕсли;
		ЭтотОбъект.ТекущийЭлемент = Элементы.ТаблицаТоваров;
		Элементы.ТаблицаТоваров.ТекущаяСтрока = СтруктураСтроки.Номенклатура;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
