﻿// СтандартныеПодсистемы.РаботаСКонтрагентами
&НаКлиенте
Перем ОтключитьЗаполнениеПоИНН;

&НаКлиенте
Перем ФормаДлительнойОперации Экспорт;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ПриСозданииНаСервере(ЭтотОбъект, Объект, "СтраницаКонтактнаяИнформация",ПоложениеЗаголовкаЭлементаФормы.Лево);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
	// Обработчик механизма "ВерсионированиеОбъектов".
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
		
	// ДополнительныеОтчетыИОбработки
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ДополнительныеОтчетыИОбработки
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		ЗаполнитьДанныеФИО();
		
		ЗаполнитьДанныеОтветственныхЛиц();
		
	Иначе
		УправлениеЭлементамиФормыНаСервере();
	КонецЕсли;
	
	ПодготовитьФормуНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
	ПодготовитьФормуНаСервере();
	УправлениеЭлементамиФормыНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если Объект.ЮрФизЛицо <>  Перечисления.ЮрФизЛицо.ИндивидуальныйПредприниматель Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "Фамилия");
	КонецЕсли;
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ОбработкаПроверкиЗаполненияНаСервере(ЭтотОбъект, Объект, Отказ);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация

	ОбновитьИнтерфейс = ТекущийОбъект.ЭтоНовый() И НЕ ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций");
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	УправлениеЭлементамиФормыНаСервере();
	
	Если ОбновитьИнтерфейс Тогда
		
		ОбновитьИнтерфейс();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ПрограммныйИнтерфейс

&НаКлиенте
Процедура ЗаполнитьРеквизитыПоИННЗавершение(Ответ, ДопПараметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ВыполнитьЗаполнениеРеквизитовПоИНН();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзменениеОтветственныхЛиц" Тогда
		
		ЗаполнитьДанныеОтветственныхЛиц();
		
	ИначеЕсли ИмяСобытия = "ЗагруженАдресныйКлассификатор" Тогда
		
		Элементы.ДекорацияАдресныйКлассификаторНеЗагружен.Видимость = АдресныйКлассификаторПуст();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Руководитель",Перечисления.ОтветственныеЛицаОрганизаций.Руководитель);
	СтруктураПараметров.Вставить("Бухгалтер",Перечисления.ОтветственныеЛицаОрганизаций.ГлавныйБухгалтер);
	СтруктураПараметров.Вставить("Кассир",Перечисления.ОтветственныеЛицаОрганизаций.Кассир);
	ЗаписатьДанныеОтветственныхЛиц(ТекущийОбъект, СтруктураПараметров);
	ЗаписатьДанныеФИО(ТекущийОбъект);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.КонтактнаяИнформация

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ЮрФизЛицоПриИзменении(Элемент)
	
	УправлениеЭлементамиФормыНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияАдресныйКлассификаторНеЗагруженОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	Если НавигационнаяСсылкаФорматированнойСтроки = "ЗагрузитьАдресныйКлассификатор" Тогда
		СтандартнаяОбработка = Ложь;
		АдресныйКлассификаторКлиент.ЗагрузитьАдресныйКлассификатор();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ВыполнитьНазначаемуюКоманду(Команда)
	
	Если НЕ ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьНазначаемуюКомандуНаКлиенте(ЭтаФорма, Команда.Имя) Тогда
		РезультатВыполнения = Неопределено;
		ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(Команда.Имя, РезультатВыполнения);
		ДополнительныеОтчетыИОбработкиКлиент.ПоказатьРезультатВыполненияКоманды(ЭтаФорма, РезультатВыполнения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияПриИзменении(Элемент)
	
	МодульУправлениеКонтактнойИнформациейКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеКонтактнойИнформациейКлиент");
	МодульУправлениеКонтактнойИнформациейКлиент.ПриИзменении(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	МодульУправлениеКонтактнойИнформациейКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеКонтактнойИнформациейКлиент");
	МодульУправлениеКонтактнойИнформациейКлиент.НачалоВыбора(ЭтотОбъект, Элемент, , СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияПриНажатии(Элемент, СтандартнаяОбработка)
	
	МодульУправлениеКонтактнойИнформациейКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеКонтактнойИнформациейКлиент");
	МодульУправлениеКонтактнойИнформациейКлиент.НачалоВыбора(ЭтотОбъект, Элемент,, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияОчистка(Элемент, СтандартнаяОбработка)
	
	МодульУправлениеКонтактнойИнформациейКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеКонтактнойИнформациейКлиент");
	МодульУправлениеКонтактнойИнформациейКлиент.Очистка(ЭтотОбъект, Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияВыполнитьКоманду(Команда)
	
	МодульУправлениеКонтактнойИнформациейКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеКонтактнойИнформациейКлиент");
	МодульУправлениеКонтактнойИнформациейКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда.Имя);
	
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ОбновитьКонтактнуюИнформацию(Результат)
	
	МодульУправлениеКонтактнойИнформацией = ОбщегоНазначения.ОбщийМодуль("УправлениеКонтактнойИнформацией");
	МодульУправлениеКонтактнойИнформацией.ОбновитьКонтактнуюИнформацию(ЭтотОбъект, Объект, Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	МодульУправлениеПечатьюКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеПечатьюКлиент");
	МодульУправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтотОбъект, Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередатьСведенияОбОрганизацииГИСМ(Команда)
	
	ДанныеОбОрганизацииXML = ИнтеграцияГИСМВызовСервера.ДанныеОбОрганизацииXML(Объект.Ссылка);
	
	Результат = ИнтеграцияГИСМКлиент.ПодписатьИОтправить(
		ДанныеОбОрганизацииXML,
		ПредопределенноеЗначение("Перечисление.ВариантыЗапросовГИСМ.ПередачаДанных"),
		"4PPJwcm26aGapV5xReWrm4aQQ3A=");
		
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СохраненныеДанныеАутентификацииСайта()
	
	Результат = ИнтернетПоддержкаПользователей.ДанныеАутентификацииПользователяИнтернетПоддержки();
	Возврат ?(Результат <> Неопределено, Результат, Новый Структура("Логин,Пароль"));
	
КонецФункции

// Процедура управляет видимостью и доступностью элементов на форме.
//
&НаСервере
Процедура УправлениеЭлементамиФормыНаСервере()
	
	ЭтоЮридическоеЛицо =  Объект.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ЮрЛицо
		ИЛИ Объект.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ЮрЛицоНеРезидент;
		
	ОбщегоНазначенияРТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "КПП", "Видимость", ЭтоЮридическоеЛицо);
	ОбщегоНазначенияРТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "РеквизитыИП", "Видимость", Не ЭтоЮридическоеЛицо);
	ОбщегоНазначенияРТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ПодменюПерейти", "Доступность", ЗначениеЗаполнено(Объект.Ссылка));
	
	Если ЭтоЮридическоеЛицо Тогда
		Элементы.ИНН.Маска = "9999999999";//10
		Элементы.КодПоОКПО.Маска = "99999999";//8
		Элементы.ОГРН.Маска = "9999999999999";//13
		Элементы.ОГРН.Заголовок = "ОГРН";
	Иначе
		Элементы.ИНН.Маска = "999999999999";//12
		Элементы.КодПоОКПО.Маска = "9999999999";//10
		Элементы.ОГРН.Маска = "999999999999999";//15
		Элементы.ОГРН.Заголовок = "ОГРН ИП";
	КонецЕсли;
	
	Элементы.ГруппаОбособленное.Видимость = ЭтоЮридическоеЛицо;
	Элементы.ГоловнаяОрганизация.Доступность = Объект.ОбособленноеПодразделение;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеОтветственныхЛиц()
	
	Руководитель = Справочники.ФизическиеЛица.ПустаяСсылка();
	Бухгалтер = Справочники.ФизическиеЛица.ПустаяСсылка();
	Кассир = Справочники.ФизическиеЛица.ПустаяСсылка();
	
	ОтветственныеЛица = Новый Массив;
	ОтветственныеЛица.Добавить(Перечисления.ОтветственныеЛицаОрганизаций.Руководитель);
	ОтветственныеЛица.Добавить(Перечисления.ОтветственныеЛицаОрганизаций.ГлавныйБухгалтер);
	ОтветственныеЛица.Добавить(Перечисления.ОтветственныеЛицаОрганизаций.Кассир);
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	ОтветственныеЛица.ФизическоеЛицо,
	                      |	ОтветственныеЛица.ОтветственноеЛицо
	                      |ИЗ
	                      |	РегистрСведений.ОтветственныеЛицаОрганизаций.СрезПоследних(
	                      |			&Период,
	                      |			СтруктурнаяЕдиница = &СтруктурнаяЕдиница
	                      |				И ОтветственноеЛицо В (&ОтветственныеЛица)) КАК ОтветственныеЛица");
	
	Запрос.УстановитьПараметр("СтруктурнаяЕдиница",Объект.Ссылка);
	Запрос.УстановитьПараметр("ОтветственныеЛица",ОтветственныеЛица);
	Запрос.УстановитьПараметр("Период",ТекущаяДатаСеанса());
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.ОтветственноеЛицо = Перечисления.ОтветственныеЛицаОрганизаций.Руководитель Тогда
			
			Руководитель = Выборка.ФизическоеЛицо;
			
		ИначеЕсли Выборка.ОтветственноеЛицо = Перечисления.ОтветственныеЛицаОрганизаций.ГлавныйБухгалтер Тогда
			
			Бухгалтер = Выборка.ФизическоеЛицо;
			
		ИначеЕсли Выборка.ОтветственноеЛицо = Перечисления.ОтветственныеЛицаОрганизаций.Кассир Тогда
			
			Кассир = Выборка.ФизическоеЛицо;

		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьДанныеОтветственныхЛиц(ТекущийОбъект, СтруктураПараметров);
	
	Для каждого КлючИЗначение Из СтруктураПараметров Цикл
		СтруктураЗаписи = РегистрыСведений.ОтветственныеЛицаОрганизаций.ПолучитьПоследнее(ТекущаяДатаСеанса(), Новый Структура("СтруктурнаяЕдиница, ОтветственноеЛицо", ТекущийОбъект.Ссылка, КлючИЗначение.Значение));
		Если СтруктураЗаписи.ФизическоеЛицо <> ЭтаФорма[КлючИЗначение.Ключ] Тогда
			МенеджерЗаписи = РегистрыСведений.ОтветственныеЛицаОрганизаций.СоздатьМенеджерЗаписи();
			МенеджерЗаписи.Период = ТекущаяДатаСеанса();
			МенеджерЗаписи.СтруктурнаяЕдиница = ТекущийОбъект.Ссылка;
			МенеджерЗаписи.ОтветственноеЛицо = КлючИЗначение.Значение;
			МенеджерЗаписи.ФизическоеЛицо = ЭтаФорма[КлючИЗначение.Ключ];
			МенеджерЗаписи.Записать();
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеФИО()
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	|	ФИОФизЛицСрезПоследних.Имя,
	|	ФИОФизЛицСрезПоследних.Отчество,
	|	ФИОФизЛицСрезПоследних.Фамилия
	|ИЗ
	|	РегистрСведений.ФИОФизЛиц.СрезПоследних(&Период, ФизЛицо = &Ссылка) КАК ФИОФизЛицСрезПоследних");
	
	Запрос.УстановитьПараметр("Ссылка",Объект.Ссылка);
	Запрос.УстановитьПараметр("Период",ТекущаяДатаСеанса());
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		
		Выборка = РезультатЗапроса.Выбрать();
		
		Если Выборка.Следующий() Тогда
			
			Фамилия = Выборка.Фамилия;
			Имя = Выборка.Имя;
			Отчество = Выборка.Отчество;
			
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ЗаписатьДанныеФИО(ТекущийОбъект)
	
	ТекущаяДатаСеанса = ТекущаяДатаСеанса();
	
	Если ТекущийОбъект.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ИндивидуальныйПредприниматель Тогда
		
		ТекущаяДатаСеанса = ТекущаяДатаСеанса();
		СтруктураЗаписи = РегистрыСведений.ФИОФизЛиц.ПолучитьПоследнее(ТекущаяДатаСеанса, Новый Структура("ФизЛицо", ТекущийОбъект.Ссылка));
		Если СтруктураЗаписи.Фамилия <> Фамилия
			ИЛИ СтруктураЗаписи.Отчество <> Отчество
			ИЛИ СтруктураЗаписи.Имя <> Имя Тогда
			МенеджерЗаписи = РегистрыСведений.ФИОФизЛиц.СоздатьМенеджерЗаписи();
			МенеджерЗаписи.ФизЛицо = ТекущийОбъект.Ссылка;
			МенеджерЗаписи.Период = ТекущаяДатаСеанса;
			МенеджерЗаписи.Фамилия = Фамилия;
			МенеджерЗаписи.Имя = Имя;
			МенеджерЗаписи.Отчество = Отчество;
			МенеджерЗаписи.Записать(Истина);
		КонецЕсли;
		
	Иначе
		
		Запрос = Новый Запрос("ВЫБРАТЬ
		|	ФИОФизЛицСрезПоследних.Имя,
		|	ФИОФизЛицСрезПоследних.Отчество,
		|	ФИОФизЛицСрезПоследних.Фамилия
		|ИЗ
		|	РегистрСведений.ФИОФизЛиц.СрезПоследних(&Период, ФизЛицо = &Ссылка) КАК ФИОФизЛицСрезПоследних");
		
		Запрос.УстановитьПараметр("Ссылка",Объект.Ссылка);
		Запрос.УстановитьПараметр("Период",ТекущаяДатаСеанса);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		Если НЕ РезультатЗапроса.Пустой() Тогда
			
			Выборка = РезультатЗапроса.Выбрать();
			Если Выборка.Фамилия <> Фамилия
				ИЛИ Выборка.Имя <> Имя
				ИЛИ Выборка.Отчество <> Отчество Тогда
				
				МенеджерЗаписи = РегистрыСведений.ФИОФизЛиц.СоздатьМенеджерЗаписи();
				МенеджерЗаписи.ФизЛицо = ТекущийОбъект.Ссылка;
				МенеджерЗаписи.Период = ТекущаяДатаСеанса;
				МенеджерЗаписи.Фамилия = Фамилия;
				МенеджерЗаписи.Имя = Имя;
				МенеджерЗаписи.Отчество = Отчество;
				МенеджерЗаписи.Записать(Истина);
				
			КонецЕсли;
						
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	Элементы.ДекорацияАдресныйКлассификаторНеЗагружен.Видимость = АдресныйКлассификаторПуст();
	
	Текст = СтрШаблон(
		НСтр("ru = 'Для автоподбора и выбора адресных сведений необходимо <a href = %1 >загрузить классификатор</a>.'"),
		"ЗагрузитьАдресныйКлассификатор");
		ФорматированнаяСтрока = СтроковыеФункцииКлиентСервер.ФорматированнаяСтрока(Текст);
		Элементы.ДекорацияАдресныйКлассификаторНеЗагружен.Заголовок = ФорматированнаяСтрока;
		
	Аутентификация = СохраненныеДанныеАутентификацииСайта();
	Элементы.ЗаполнитьПоИНН.Видимость = НЕ ПустаяСтрока(Аутентификация.Пароль);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция АдресныйКлассификаторПуст()
	Возврат НЕ АдресныйКлассификатор.КлассификаторЗагружен();
КонецФункции

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента, РезультатВыполнения)
	
	ДополнительныеОтчетыИОбработки.ВыполнитьНазначаемуюКомандуНаСервере(ЭтаФорма, ИмяЭлемента, РезультатВыполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоИНН(Команда)
	
	Если ОтключитьЗаполнениеПоИНН <> Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.ИНН) Тогда
		ПоказатьПредупреждение(, НСтр("ru='Поле ""ИНН"" не заполнено'"));
		ТекущийЭлемент = Элементы.ИНН;
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Наименование) 
		ИЛИ ЗначениеЗаполнено(Объект.НаименованиеПолное) 
		ИЛИ ЗначениеЗаполнено(Объект.КПП) Тогда
		ТекстВопроса = НСтр("ru='Перезаполнить текущие реквизиты?'");
		ОписаниеОповещения = Новый ОписаниеОповещения("ЗаполнитьРеквизитыПоИННЗавершение", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	Иначе
		ВыполнитьЗаполнениеРеквизитовПоИНН();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьGLNПоИННКППГИСМ(Команда) Экспорт
	
	Если Не ЗначениеЗаполнено(Объект.ИНН) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не заполнено поле ""ИНН""'"), Объект.Ссылка, "Объект.ИНН");
		Возврат;
	КонецЕсли;
	
	СообщениеЗапросаGLN = ИнтеграцияГИСМВызовСервера.СообщениеЗапросаGLN(Объект.Ссылка, Объект.ИНН, Объект.КПП);
	Если ЗначениеЗаполнено(СообщениеЗапросаGLN.ТекстОшибки) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеЗапросаGLN.ТекстОшибки, Объект.Ссылка);
		Возврат;
	КонецЕсли;
	
	Сообщения = Новый Массив;
	Сообщения.Добавить(СообщениеЗапросаGLN);
	СообщенияПоОрганизациям = ИнтеграцияГИСМКлиент.СообщенияПоОрганизациям(Сообщения);
	
	Данные = ИнтеграцияГИСМКлиент.СообщенияСледующейОрганизацииКПодписанию(СообщенияПоОрганизациям);
	Если Данные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Контекст = Новый Структура;
	ИнтеграцияГИСМКлиент.Подписать(
		Данные.Сообщения,
		Данные.Организация,
		Новый ОписаниеОповещения("ПолучитьGLNПоИННКППГИСМ_ПриЗавершенииОперацииПодписи", ЭтотОбъект, Контекст));
	
КонецПроцедуры

Процедура ПолучитьGLNПоИННКППГИСМ_ПриЗавершенииОперацииПодписи(Сообщения, ДополнительныеПараметры) Экспорт
	
	Если Сообщения = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Сообщения.Количество() <> 1 Тогда
		Возврат;
	КонецЕсли;
	
	Результат = ИнтеграцияГИСМВызовСервера.ОбработатьПодписанноеСообщениеЗапросаGLN(Сообщения[0]);
	
	Если ЗначениеЗаполнено(Результат.GLN) Тогда
		Объект.GLN = Результат.GLN;
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Результат.ТекстОшибки);
	КонецЕсли;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

&НаКлиенте
Процедура ВыполнитьЗаполнениеРеквизитовПоИНН()
	
	ОписаниеОшибки = "";
	ЗаполнитьРеквизитыПоИНННаСервере(ОписаниеОшибки);
	
	Если ЗначениеЗаполнено(ОписаниеОшибки) Тогда
		// Обработка ошибок
		Если ОписаниеОшибки = "НеУказаныПараметрыАутентификации" Тогда
			ТекстВопроса = НСтр("ru='Для автоматического заполнения реквизитов организации
				|необходимо подключиться к Интернет-поддержке пользователей.
				|Подключиться сейчас?'");
			ОписаниеОповещения = Новый ОписаниеОповещения("ПодключитьИнтернетПоддержку", ЭтотОбъект);
			ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		Иначе
			ПоказатьПредупреждение(, ОписаниеОшибки);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРеквизитыПоИНННаСервере(ОписаниеОшибки = "")
	
	ЭтоЮридическоеЛицо = Объект.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ЮрЛицо;
	Если ЭтоЮридическоеЛицо Тогда
		РеквизитыКонтрагента = ДанныеЕдиныхГосРеестров.РеквизитыЮридическогоЛицаПоИНН(Объект.ИНН);
	Иначе
		РеквизитыКонтрагента = ДанныеЕдиныхГосРеестров.РеквизитыПредпринимателяПоИНН(Объект.ИНН);
	КонецЕсли;
	Если ЗначениеЗаполнено(РеквизитыКонтрагента.ОписаниеОшибки) Тогда
		ОписаниеОшибки = РеквизитыКонтрагента.ОписаниеОшибки;
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(Объект, РеквизитыКонтрагента);
	
	Если ЭтоЮридическоеЛицо Тогда
		ЗаполнитьЭлементКонтактнойИнформации(Справочники.ВидыКонтактнойИнформации.ЮрАдресКонтрагента, 
			РеквизитыКонтрагента.ЮридическийАдрес);
	КонецЕсли;
	
	Модифицированность = Истина;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьЭлементКонтактнойИнформации(ВидКонтактнойИнформации, СтруктураДанных)
	
	Если СтруктураДанных = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Отбор = Новый Структура("Вид", ВидКонтактнойИнформации);
	Строки = ЭтотОбъект.КонтактнаяИнформацияОписаниеДополнительныхРеквизитов.НайтиСтроки(Отбор);
	ДанныеСтроки = ?(Строки.Количество() = 0, Неопределено, Строки[0]);
	Если ДанныеСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ДанныеСтроки.Представление = СтруктураДанных.Представление;
	ДанныеСтроки.ЗначенияПолей = СтруктураДанных.КонтактнаяИнформация;
	ЭтотОбъект[ДанныеСтроки.ИмяРеквизита] = СтруктураДанных.Представление;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбособленноеПодразделениеПриИзменении(Элемент)
	
	ОбособленноеПодразделениеПриИзмененииСервер();
	
КонецПроцедуры

&НаСервере
Процедура ОбособленноеПодразделениеПриИзмененииСервер()
	Если НЕ Объект.ОбособленноеПодразделение Тогда
		Объект.ГоловнаяОрганизация = Справочники.Организации.ПустаяСсылка();
	КонецЕсли;
	УправлениеЭлементамиФормыНаСервере();
КонецПроцедуры

#КонецОбласти