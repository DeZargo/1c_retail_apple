﻿
&НаКлиенте
Процедура Команда1(Команда)
	
	Если не ЗначениеЗаполнено(оборудования) Тогда
		Сообщить("Не заполнен список весов в поле Оборудования !!!");
		возврат;
	КонецЕсли;
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Магазин",    Неопределено);
	ПараметрыФормы.Вставить("Контрагент", Неопределено);
	ПараметрыФормы.Вставить("СсылкаНаПоступление", Неопределено);
	ПараметрыФормы.Вставить("ЦенаВключаетНДС", истина);
	ПараметрыФормы.Вставить("РежимПодбораВЗакупки", Ложь);
	ПараметрыФормы.Вставить("ИспользоватьОтборПоТипамНоменклатуры", Ложь);
	ПараметрыФормы.Вставить("Склад", Неопределено);
	ПараметрыФормы.Вставить("Заголовок", "уруру");
	ПараметрыФормы.Вставить("Дата", ТекущаяДата());
	
	ОткрытьФорму("Обработка.ПодборТоваров.Форма",ПараметрыФормы, ЭтаФорма, УникальныйИдентификатор);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	ОбработкаВыбораСервер(ВыбранноеЗначение);	
КонецПроцедуры

Процедура ОбработкаВыбораСервер(ВыбранноеЗначение)
	ТаблицаТоваров = ПолучитьИзВременногоХранилища(ВыбранноеЗначение.АдресТоваровВХранилище);
	Запрос=Новый запрос;
	Запрос.Текст="ВЫБРАТЬ ПЕРВЫЕ 1
	             |	ххх_КодыНоменклатурыВесыКассы.Инкримента КАК Инкримента
	             |ИЗ
	             |	РегистрСведений.ххх_КодыНоменклатурыВесыКассы КАК ххх_КодыНоменклатурыВесыКассы
	             |
	             |УПОРЯДОЧИТЬ ПО
	             |	Инкримента УБЫВ";
	Выборка=Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Если выборка.Инкримента<2 Тогда
			СтараяИнкримента=2;
		Иначе
			СтараяИнкримента=выборка.Инкримента;	
		КонецЕсли;
	Иначе
		СтараяИнкримента=1;
	КонецЕсли;
	Инкримента=СтараяИнкримента+1;
	
	список1=оборудования.ВыгрузитьЗначения();
	Для каждого оборудование из список1 Цикл
		ячейка=ПолучитьПоследниюЯчейкуНаВесах(Оборудование);
		Для каждого стр из ТаблицаТоваров Цикл
			
			наб=РегистрыСведений.ххх_КодыНоменклатурыВесыКассы.СоздатьНаборЗаписей();
			наб.Отбор.Оборудование.установить(оборудование);
			наб.Прочитать();
			нОМЕРА=нАБ.ВыгрузитьКолонку("НомерДляСостава");
			НомерДляСостава=1;		
			Пока ЗначениеЗаполнено(нОМЕРА.Найти(НомерДляСостава)) или нОМЕРА.Найти(НомерДляСостава)=0 Цикл
				НомерДляСостава=НомерДляСостава+1;
			КонецЦикла;

			мен=РегистрыСведений.ххх_КодыНоменклатурыВесыКассы.СоздатьМенеджерЗаписи();
			мен.Оборудование=оборудование;
			мен.НомерДляСостава=НомерДляСостава;
			мен.Номенклатура=стр.номенклатура;
			мен.Инкримента=Инкримента;
			мен.код=ячейка;
			попытка
				мен.Записать(Ложь);
			Исключение сообщить(Строка(стр.номенклатура)+" Уже есть в матрице весов: "+оборудование+" в ячейке: "+ячейка);
			КонецПопытки;
			Инкримента=Инкримента+1;
			ячейка=ячейка+1;
		КонецЦикла;
	КонецЦикла;
//	
КонецПроцедуры








Функция ПолучитьПоследниюЯчейкуНаВесах(Оборудование)	
	
	Если Значениезаполнено(Оборудование) Тогда
		
		Запрос=Новый запрос;
		Запрос.УстановитьПараметр("Весы",Оборудование);
		Запрос.Текст="ВЫБРАТЬ ПЕРВЫЕ 1
		             |	ххх_КодыНоменклатурыВесыКассы.Код КАК Код,
		             |	ххх_КодыНоменклатурыВесыКассы.Оборудование КАК Оборудование
		             |ИЗ
		             |	РегистрСведений.ххх_КодыНоменклатурыВесыКассы КАК ххх_КодыНоменклатурыВесыКассы
		             |ГДЕ
		             |	ххх_КодыНоменклатурыВесыКассы.Оборудование = &весы
		             |
		             |УПОРЯДОЧИТЬ ПО
		             |	Код УБЫВ";
		выборка=Запрос.Выполнить().Выбрать();
		Если выборка.Следующий() Тогда
			Код=Выборка.Код+1;
		Иначе
			Код=1;
		КонецЕсли;
	КонецЕсли;
	возврат код;	
КонецФункции

&НаСервереБезКонтекста
Процедура ПерезаполнитьСостояниеВВесахУНоменклатурыНаСервере()
	
	
	наб=РегистрыСведений.ДополнительныеСведения.СоздатьНаборЗаписей();
	наб.Отбор.Свойство.установить(Справочники.ххх_Справочник.СостояниеНаВесах.Значение);
	//Наб.Прочитать();
	//наб.Очистить();
	наб.Записать(Истина);
	
	наб=РегистрыСведений.ххх_КодыНоменклатурыВесыКассы.СоздатьНаборЗаписей();
	наб.Прочитать();
	наб.Записать(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПерезаполнитьСостояниеВВесахУНоменклатуры(Команда)
	ПерезаполнитьСостояниеВВесахУНоменклатурыНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если не РольДоступна("ПолныеПрава") Тогда
		Элементы.ФормаПерезаполнитьСостояниеВВесахУНоменклатуры.Доступность=Ложь;
		Элементы.ФормаСместитьНа1000.Видимость=Ложь;
	Иначе
		ххх_КолвоДобавляемоеКЯчейкам=ПолучитьЗначениеКолвоДобавляемоеКЯчейкам();		
		Элементы.ФормаСместитьНа1000.Заголовок="Сместить на "+ххх_КолвоДобавляемоеКЯчейкам;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СместитьНа1000НаСервере(Оборудование)
	
	
	наб=РегистрыСведений.ххх_КодыНоменклатурыВесыКассы.СоздатьНаборЗаписей();
	наб.Отбор.Оборудование.установить(Оборудование);
	наб.Прочитать();
	тз=наб.Выгрузить();
	тз.Сортировать("код Убыв");
	
	Если (тз[0].код+ххх_КолвоДобавляемоеКЯчейкам)>4000 Тогда
		Сообщить("Колво ячеек превысило 4000! Нельзя увеличить на "+ххх_КолвоДобавляемоеКЯчейкам);
		возврат;
	ИначеЕсли (тз[0].код+ххх_КолвоДобавляемоеКЯчейкам)<=0 Тогда
		Сообщить("Колво ячеек меньше 1! Нельзя уменьшить на "+(-ххх_КолвоДобавляемоеКЯчейкам));
		возврат;
	КонецЕсли;
	
	Для каждого стр из тз цикл
		стр.код=стр.код+ххх_КолвоДобавляемоеКЯчейкам;	
	КонецЦикла;
	
	НачатьТранзакцию();
	
	наб.Очистить();
	наб.Записать();
	
	наб.Загрузить(тз);
	наб.Записать();
	
	ЗафиксироватьТранзакцию();
	//ОтменитьТранзакцию();
	
КонецПроцедуры

&НаКлиенте
Процедура СместитьНа1000(Команда)
	
	Оповещение = Новый ОписаниеОповещения("СместитьНа1000Оповещение",ЭтаФорма);


	ПоказатьВопрос(Оповещение, "По весам: "+Элементы.Список.ТекущиеДанные.Оборудование+" будет произведено смещение на "+ххх_КолвоДобавляемоеКЯчейкам+", вы уверены?",
		РежимДиалогаВопрос.ОКОтмена);

	
	
КонецПроцедуры



&НаСервереБезКонтекста
функция ПолучитьЗначениеКолвоДобавляемоеКЯчейкам()
	
	Возврат константы.ххх_КолвоДобавляемоеКЯчейкам.Получить();
	
КонецФункции




&НаКлиенте
Процедура СместитьНа1000Оповещение(Ответ,йцу) экспорт
	
	Если Ответ=КодВозвратаДиалога.ОК Тогда
		СместитьНа1000НаСервере(Элементы.Список.ТекущиеДанные.Оборудование);
	КонецЕсли;

КонецПроцедуры










































