/*
 * Waxeye Parser Generator
 * www.waxeye.org
 * Copyright (C) 2008 Orlando D. A. R. Hill
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
 * of the Software, and to permit persons to whom the Software is furnished to do
 * so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
package org.waxeye.parser;

import org.waxeye.ast.IAST;

/**
 * A transition cost of matching an automaton.
 *
 * @param <E> The AST type.
 *
 * @author Orlando Hill
 */
public final class AutomatonTransition <E extends Enum<?>> implements ITransition<E>
{
    /** The index of the automaton. */
    private final int index;

    /**
     * Create a new AutomatonTransition.
     *
     * @param index The index of the automaton.
     */
    public AutomatonTransition(final int index)
    {
        this.index = index;
    }

    /**
     * Returns the index.
     *
     * @return Returns the index.
     */
    public int getIndex()
    {
        return index;
    }

    /** {@inheritDoc} */
    public IAST<E> acceptVisitor(final ITransitionVisitor<E> visitor)
    {
        return visitor.visitAutomatonTransition(this);
    }
}
