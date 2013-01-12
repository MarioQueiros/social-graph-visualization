using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Text;

public class Graphs4Social_Service : IGraphs4Social_Service
{
    public void DoWork()
    {
    }

    public int Add(int x, int y)
    {
        return (x + y);
    }

    

}