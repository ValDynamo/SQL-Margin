using KeyAttribute = System.ComponentModel.DataAnnotations.KeyAttribute;

namespace API.MarginSKU.Domain.Entities
{
    public class Good
    {
        public int GoodId { get; set; }
        public string Name { get; set; }

    }
}
