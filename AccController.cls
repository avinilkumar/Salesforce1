public class AccController
{

    public list<EPAccWrapper> EPAccWrapperList 
    {
        get;
        set;
    }
    
    public string parentaccid 
    {
        get;
        set;
    }
    
    public AccController(ApexPages.StandardController accountcontroller)
    {
        parentaccid = Apexpages.currentPage().getParameters().get('parentId');
    }
    
    public List<EPAccWrapper> getWrapperAccounts()
    {
        EPAccWrapperList = new list<EPAccWrapper>();
        for(Account acc :[select id,name,EPF_Account__c,phone,AccountNumber from account where  EPF_Account__c = null])// put where condition to filter only physcian account
        {    
            EPAccWrapperList.add(new EPAccWrapper(acc,false) );
        }
        return EPAccWrapperList;
    }
    
    public pagereference SaveEPACc()
    {
        list<Account> accountToUpdate = new list<Account>();
        for(EPAccWrapper ep:EPAccWrapperList)
        {
            if(ep.selectAcc)
            {
                accountToUpdate.add(ep.accEP);
            }
        }
        for(Account acc : accountToUpdate)
        {
             acc.EPF_Account__c = parentaccid;
        }
        update accountToUpdate;
        pagereference pg = new pagereference('/'+parentaccid);
        pg.setredirect(true);
        return pg;
    }
    public class EPAccWrapper
    {
        public boolean selectAcc{get;set;}
        public Account accEP{get;set;}
        public EPAccWrapper(Account acc, boolean isselect)
        {
            selectAcc = isselect;
            accEp = acc; 
        }
    }
}