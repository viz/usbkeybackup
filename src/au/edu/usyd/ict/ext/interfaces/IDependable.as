package au.edu.usyd.ict.ext.interfaces
{
	public interface IRequireable
	{
		public function requires(dependency:IRequireable):void
		public function requirementsSatisfied():Boolean
		
		
	}
}