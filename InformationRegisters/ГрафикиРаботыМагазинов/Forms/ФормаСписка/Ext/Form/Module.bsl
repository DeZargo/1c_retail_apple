﻿#Область ПрограммныйИнтерфейс

&НаКлиенте
Процедура ОповещениеВопросОбУдаленииДанных(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	ТекущаяСтрока = Элементы.ТаблицаСписка.ТекущиеДанные;
	Отбор = Новый Структура("Магазин,Год",ТекущаяСтрока.Магазин,ТекущаяСтрока.Год);
	ОчиститьНаборЗаписейГрафикаРаботыПоОтбору(Отбор);
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Отбор.Свойство("Магазин") Тогда
	
		Магазин = Параметры.Отбор.Магазин;
		
		Если ТипЗнч(Магазин) = Тип("СправочникСсылка.Магазины") И ЗначениеЗаполнено(Магазин) Тогда
			ТекстЗаголовка = "";
			АвтоЗаголовок  = Ложь;
			ТекстЗаголовка = НСтр("ru = 'Графики работы (%Магазин%)'");
			ТекстЗаголовка = СтрЗаменить(ТекстЗаголовка, "%Магазин%", Строка(Магазин));
			Заголовок      = ТекстЗаголовка;
		КонецЕсли;
		
	КонецЕсли;
	
	ЗаполнитьТаблицуСписка();
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ГрафикРаботыИзменен" Тогда
		
		ЗаполнитьТаблицуСписка();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
    
    // &ЗамерПроизводительности
    ОценкаПроизводительностиРТКлиент.НачатьЗамер(
             Истина, "РегистрСведений.ГрафикиРаботыМагазинов.Форма.ФормаСписка.Открытие");

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТаблицаСписка

&НаКлиенте
Процедура ТаблицаСпискаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьФормуРедактированияГрафикаМагазина();
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаСпискаПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если Копирование Тогда
		КопироватьГрафикРаботыМагазина(Отказ)
	Иначе
		НовыйГрафикМагазинаКлиент(Отказ)
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаСпискаПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	ОткрытьФормуРедактированияГрафикаМагазина();
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаСпискаПередУдалением(Элемент, Отказ)
	
	УдалитьГрафикРаботыМагазина(Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НапечататьГрафикРаботыМагазина(Команда)
	
	ТекущаяСтрока = Элементы.ТаблицаСписка.ТекущиеДанные;
	Если ТекущаяСтрока <> Неопределено Тогда
		
		СтруктураОбъекта = Новый Структура;
		СтруктураОбъекта.Вставить("Магазин", ТекущаяСтрока.Магазин);
		СтруктураОбъекта.Вставить("Год",     ТекущаяСтрока.Год);
		
		ПараметрКоманды = Новый Массив;
		ПараметрКоманды.Добавить(ТекущаяСтрока.Магазин); 
		
		УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
			"Справочник.Магазины",
			"ГрафикРаботы",
			ПараметрКоманды,
			ЭтотОбъект,
			СтруктураОбъекта
		);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОчиститьНаборЗаписейГрафикаРаботыПоОтбору(Отбор)
	
	Набор = РегистрыСведений.ГрафикиРаботыМагазинов.СоздатьНаборЗаписей();
	Набор.Отбор.Магазин.Установить(Отбор.Магазин);
	Набор.Отбор.Год.Установить(Отбор.Год);
	Набор.Прочитать();
	Набор.Очистить();
	Набор.Записать();
	
	ЗаполнитьТаблицуСписка();
КонецПроцедуры

&НаКлиенте
Процедура НовыйГрафикМагазинаКлиент(Отказ = Ложь);
	
	Отказ = Истина;
	Если ЗначениеЗаполнено(Магазин)  Тогда
        
        // &ЗамерПроизводительности
        ОценкаПроизводительностиРТКлиент.НачатьЗамер(
                 Истина, "РегистрСведений.ГрафикиРаботыМагазинов.Форма.ФормаНабораЗаписей.Открытие");

		Отбор = Новый Структура("Магазин", Магазин);
		
		ОткрытьФорму("РегистрСведений.ГрафикиРаботыМагазинов.Форма.ФормаНабораЗаписей",Новый Структура("Отбор",Отбор),ЭтотОбъект);
		
	Иначе
        
        // &ЗамерПроизводительности
        ОценкаПроизводительностиРТКлиент.НачатьЗамер(
                 Истина, "РегистрСведений.ГрафикиРаботыМагазинов.Форма.ФормаНабораЗаписей.Открытие");

		ОткрытьФорму("РегистрСведений.ГрафикиРаботыМагазинов.Форма.ФормаНабораЗаписей",,ЭтотОбъект);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуСписка()
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	РегистрСведенийГрафикРаботы.Магазин,
	|	РегистрСведенийГрафикРаботы.Год КАК Год
	|ИЗ
	|	РегистрСведений.ГрафикиРаботыМагазинов КАК РегистрСведенийГрафикРаботы
	|ГДЕ
	|	(&Магазин = ЗНАЧЕНИЕ(Справочник.Магазины.ПустаяСсылка)
	|			ИЛИ РегистрСведенийГрафикРаботы.Магазин = &Магазин)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Год";
	
	Запрос.УстановитьПараметр("Магазин", Магазин);
	
	Результат = Запрос.Выполнить();
	
	ТаблицаСписка.Загрузить(Результат.Выгрузить());
	
КонецПроцедуры

&НаКлиенте
Процедура КопироватьГрафикРаботыМагазина(Отказ)
	
	Отказ = Истина;
	ТекущаяСтрока = Элементы.ТаблицаСписка.ТекущиеДанные;
	
	Если ТекущаяСтрока <> Неопределено Тогда
		// &ЗамерПроизводительности
        ОценкаПроизводительностиРТКлиент.НачатьЗамер(
                 Истина, "РегистрСведений.ГрафикиРаботыМагазинов.Форма.ФормаНабораЗаписей.Открытие");

		Отбор = Новый Структура("Магазин",ТекущаяСтрока.Магазин);
		
		ОткрытьФорму("РегистрСведений.ГрафикиРаботыМагазинов.Форма.ФормаНабораЗаписей",Новый Структура("Отбор",Отбор), ЭтотОбъект);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуРедактированияГрафикаМагазина()
	
	ТекущаяСтрока = Элементы.ТаблицаСписка.ТекущиеДанные;
	
	Если ТекущаяСтрока <> Неопределено Тогда
        
        // &ЗамерПроизводительности
        ОценкаПроизводительностиРТКлиент.НачатьЗамер(
                 Истина, "РегистрСведений.ГрафикиРаботыМагазинов.Форма.ФормаНабораЗаписей.Открытие");
                 
		Отбор = Новый Структура("Магазин,Год",ТекущаяСтрока.Магазин,ТекущаяСтрока.Год);
		
		ОткрытьФорму("РегистрСведений.ГрафикиРаботыМагазинов.Форма.ФормаНабораЗаписей",Новый Структура("Отбор",Отбор), ЭтотОбъект);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьГрафикРаботыМагазина(Отказ)
	
	Отказ = Истина;
	ТекущаяСтрока = Элементы.ТаблицаСписка.ТекущиеДанные;
	
	Если ТекущаяСтрока <> Неопределено Тогда
		
		ТекстВопроса = НСтр("ru='Удалить данные по магазину %1 за год %2?'");
		ТекстВопроса = СтрЗаменить(ТекстВопроса,"%1", ТекущаяСтрока.Магазин);
		ТекстВопроса = СтрЗаменить(ТекстВопроса,"%2", Формат(ТекущаяСтрока.Год, "ЧГ=0"));
		
		ОбработчикОповещения = Новый ОписаниеОповещения("ОповещениеВопросОбУдаленииДанных", ЭтотОбъект);
		ПоказатьВопрос(ОбработчикОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
