﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	КлючевыеРеквизиты = Новый Массив;
	КлючевыеРеквизиты.Добавить("СерийныйНомер");
	
	ОбщегоНазначенияРТ.ПроверитьНаличиеДублейСтрокТЧ(ЭтотОбъект, "СерийныеНомера", КлючевыеРеквизиты, Отказ);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
