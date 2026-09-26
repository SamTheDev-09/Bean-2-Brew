import { useState } from 'react'
import { CATEGORIES, menuItems } from '../data/menu'

function MenuSection() {
  const [activeFilter, setActiveFilter] = useState('All')

  const filteredItems = activeFilter === 'All'
    ? menuItems
    : menuItems.filter(item => item.category === activeFilter)

  const getCategoryColor = (category) => {
    const colors = {
      Coffee: 'bg-espresso',
      Tea: 'bg-sage',
      Pastries: 'bg-terracotta',
      Seasonal: 'bg-cream border-2 border-espresso'
    }
    return colors[category] || 'bg-espresso'
  }

  return (
    <section id="menu" className="scroll-mt-20 py-16 px-4">
      <div className="container mx-auto max-w-6xl">
        {/* Heading */}
        <div className="text-center mb-12">
          <h2 className="text-4xl md:text-5xl font-display font-semibold text-espresso mb-4">
            What We're Pouring
          </h2>
          <p className="text-lg text-espresso/70 max-w-2xl mx-auto">
            A few favorites — the full menu's even bigger in person.
          </p>
        </div>

        {/* Filter buttons */}
        <div className="flex flex-wrap justify-center gap-3 mb-12">
          <button
            onClick={() => setActiveFilter('All')}
            className={`px-6 py-2 rounded-full font-medium transition-colors ${
              activeFilter === 'All'
                ? 'bg-terracotta text-cream'
                : 'bg-cream text-espresso hover:bg-terracotta/10'
            }`}
          >
            All
          </button>
          {CATEGORIES.map(category => (
            <button
              key={category}
              onClick={() => setActiveFilter(category)}
              className={`px-6 py-2 rounded-full font-medium transition-colors ${
                activeFilter === category
                  ? 'bg-terracotta text-cream'
                  : 'bg-cream text-espresso hover:bg-terracotta/10'
              }`}
            >
              {category}
            </button>
          ))}
        </div>

        {/* Menu grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mb-8">
          {filteredItems.map((item, index) => (
            <div
              key={index}
              className="bg-cream rounded-lg p-6 hover:shadow-lg transition-shadow"
            >
              <div className="flex items-start justify-between mb-3">
                <div className="flex-1">
                  <h3 className="text-xl font-display font-semibold text-espresso mb-1">
                    {item.name}
                  </h3>
                  <p className="text-lg font-medium text-terracotta">
                    {item.price}
                  </p>
                </div>
                <div
                  className={`w-10 h-10 rounded-full flex items-center justify-center text-cream font-display font-semibold ${getCategoryColor(item.category)}`}
                >
                  {item.name[0]}
                </div>
              </div>
              <p className="text-espresso/70">
                {item.description}
              </p>
            </div>
          ))}
        </div>

        {/* Footnote */}
        <p className="text-center text-sm text-espresso/60 italic">
          Menu is seasonal and subject to change — see us in person for the full lineup.
        </p>
      </div>
    </section>
  )
}

export default MenuSection
