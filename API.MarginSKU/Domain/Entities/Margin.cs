namespace API.MarginSKU.Domain.Entities
{
    public class Margin
    {
        public DateTime Date { get; set; }
        public int CustomerId { get; set; }
        public int GoodID { get; set; }
        public int ProjectId { get; set; }
        public string CustomerName { get; set; }
        public string GoodName { get; set; }
        public string ProjectName { get; set; }
        public double Quantity { get; set; }
        public double Revenues { get; set; }
        public double SummaCostGoods { get; set; }
        public double GrossProfit { get; set; }
        public double CostMargin { get; set; }
        public double Profit { get; set; }
    }
}
