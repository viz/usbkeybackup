package au.edu.usyd.ict.ext.interfaces
{
	import au.edu.usyd.ict.ext.StartupManager;
	
	public interface IStartupElement
	{
		function init():void
		
		function get startup():StartupManager
		
		function set startup(mgr:StartupManager):void
		
	}
}