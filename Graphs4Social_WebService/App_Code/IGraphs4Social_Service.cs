using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Text;

[ServiceContract]
public interface IGraphs4Social_Service
{
	[OperationContract]
	void DoWork();
}
