declare Days Months PrettyPrint
Days = {Dictionary.new}
{Dictionary.put Days 1 sunday}
{Dictionary.put Days 2 monday}
{Dictionary.put Days 3 tuesday}
{Dictionary.put Days 4 wednesday}
{Dictionary.put Days 5 thursday}
{Dictionary.put Days 6 friday}
{Dictionary.put Days 7 saturday}
Months = {Dictionary.new}
{Dictionary.put Months 1 january}
{Dictionary.put Months 2 february}
{Dictionary.put Months 3 march}
{Dictionary.put Months 4 april}
{Dictionary.put Months 5 may}
{Dictionary.put Months 6 june}
{Dictionary.put Months 7 july}
{Dictionary.put Months 8 august}
{Dictionary.put Months 9 september}
{Dictionary.put Months 10 october}
{Dictionary.put Months 11 november}
{Dictionary.put Months 12 december}
proc {PrettyPrint DD MM}
   {Browse [{Dictionary.get Days DD}
	    {Dictionary.get Months MM}]}
end
{PrettyPrint 3 12}
