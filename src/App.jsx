import Header from './components/Header'
import Hero from './components/Hero'
import MenuSection from './components/MenuSection'

function App() {
  return (
    <>
      <div id="top"></div>
      <Header />
      <main>
        <Hero />
        <MenuSection />
        <section id="story" className="scroll-mt-20">
          <h2>Why We Started Pouring</h2>
        </section>
        <section id="gallery" className="scroll-mt-20">
          <h2>A Look Inside</h2>
        </section>
        <section id="visit" className="scroll-mt-20">
          <h2>Come Say Hi</h2>
        </section>
        <section id="newsletter" className="scroll-mt-20">
          <h2>Stay in the Loop</h2>
        </section>
        <section id="contact" className="scroll-mt-20">
          <h2>Say Hello</h2>
        </section>
      </main>
      <footer>Footer (T2.10)</footer>
    </>
  )
}

export default App
